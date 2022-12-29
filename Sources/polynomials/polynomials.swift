



import Accelerate



public struct Polynomial {
   
    var coeffs = [Double]()

    public init(coefficients: Double...) {

        
        self.coeffs = coefficients
        
    }
    
    
    public func degree() -> Int{
        return self.coeffs.count - 1
    }
    
    var leadingCoeff: Double{
        return coeffs[0]
    }
    
    var monic: Bool {
        if self.coeffs.count == 0 { return false }
        return self.coeffs[0] == 1.0
    }
    
    
    mutating func makeMonic(){
        // Divides the polynomial with the leading coefficient to make the polynomial monic
        let l = self.leadingCoeff

        for (idx, coeff) in self.coeffs.enumerated() {
            self.coeffs[idx] = coeff / l
        }
        
    }
    
    private func companionMatrix() throws -> [__CLPK_doublereal] {
        if !self.monic { throw "Polynomial has to be monic to form companion matrix!" }
        let n = self.degree()
        
        
        let c = [Double](repeating: 0, count: n)
        var mat = [[Double]](repeating: c, count: n)
        
        var lastCol = [Double]()

        for i in (1...n).reversed() {
            lastCol.append(-self.coeffs[i])
        }

        mat[n-1] = lastCol

        for i in 0..<n-1{
            var col: [Double] = Array(repeating: 0, count: n)
            col[i + 1] = 1
            mat[i] = col
        }

        
        var flattened = [Double]()
        
        for i in 0..<n{
            for j in 0..<n{
                flattened.append(mat[j][i])
            }
        }
        
        let matrix:[__CLPK_doublereal] = flattened
        
        return matrix
    }
    
    
    mutating func roots() throws -> [Complex] {
        self.makeMonic()
        var roots = [Complex]()
        let eigenvalues = try eigenvalues()
        for (real, img) in zip(eigenvalues.0, eigenvalues.1){
            roots.append(Complex(real: real, img: img))
        }
        
        return roots
    }
    
    public func realRoots() throws -> [Double] {
        var realRoots = [Double]()
        let eigenvalues = try eigenvalues()
        for (real, img) in zip(eigenvalues.0, eigenvalues.1){
            if img == 0{
                realRoots.append(real)
            }
        }
        
        return realRoots
    }
    
    
    public func positiveRoots() throws -> [Double] {
        var realRoots = try self.realRoots()
        var positiveRoots = [Double]()

        for root in realRoots {
            if root > 0 {
                positiveRoots.append(root)
            }
        }
        
        return positiveRoots
    }
    
    
    
    public func eigenvalues() throws -> ([Double], [Double]) {
        // Calculates the eigenvalues of the companion matrix using LAPACK and dgeev_
        // https://netlib.org/lapack/explore-html/d9/d8e/group__double_g_eeigen_ga66e19253344358f5dee1e60502b9e96f.html
        // returns two arrays A and B, A holds the real parts and B the imaginary parts
        
        var V = try self.companionMatrix()
        
        var N = __CLPK_integer(self.degree())
        
        var LDA = N
        
        var wkOpt = __CLPK_doublereal(0.0)
        var lWork = __CLPK_integer(-1)
        
        var jobvl: Int8 = 86 // 'V'
        var jobvr: Int8 = 86 // 'V'
        
        var error = __CLPK_integer(0)
        
        // Real parts of eigenvalues
        var wr = [Double](repeating: 0, count: Int(N))
        // Imaginary parts of eigenvalues
        var wi = [Double](repeating: 0, count: Int(N))
        // Left eigenvectors
        var vl = [__CLPK_doublereal](repeating: 0.0, count: Int(N * N))
        // Right eigenvectors
        var vr = [__CLPK_doublereal](repeating: 0.0, count: Int(N * N))
        
        var ldvl = N
        var ldvr = N
        
        /* Query and allocate the optimal workspace */
        
        dgeev_(&jobvl, &jobvr, &N, &V, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &wkOpt, &lWork, &error)
        
        lWork = __CLPK_integer(wkOpt)
        let workspaceQuery = [Double](repeating: 0, count: 1)
        var work = [Double](repeating: 0, count: Int(workspaceQuery[0]))
        
        /* Compute eigen vectors */
        
        dgeev_(&jobvl, &jobvr, &N, &V, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &work, &lWork, &error)
        
        precondition(error == 0, "Failed to compute eigen vectors")
        
        return (wr, wi)
    }
    
}
