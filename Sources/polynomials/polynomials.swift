



import Accelerate



public struct Polynomial {
   
    var coeffs = [Double]()

    public init(coefficients: Double...) {
        // STRIP LEADING ZEROS
        var stripped: [Double] = coefficients

        for coeff in coefficients {
            if coeff == 0.0 {
                stripped = Array(stripped[1...stripped.count-1])
            } else {
                break
            }
        }
        
        self.coeffs = stripped
    }
    
    public init(coefficients: [Double]) {
        var stripped: [Double] = coefficients

        for coeff in coefficients {
            if coeff == 0.0 {
                stripped = Array(stripped[1...stripped.count-1])
            } else {
                break
            }
        }
        
        self.coeffs = coefficients
    }
    
    
    mutating func roundCoeffs(){
        // ROUND
        for (idx, coeff) in self.coeffs.enumerated() {
            self.coeffs[idx] = Round(value: coeff)
        }
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
    
    func monicCopy() -> Polynomial {
        // Returns a monic copy of the polynomial without altering the instance
        let l = self.leadingCoeff

        var copy = Polynomial(coefficients: self.coeffs)
        for (idx, coeff) in self.coeffs.enumerated() {
            copy.coeffs[idx] = coeff / l
        }
        return copy
    }
    
    mutating func makeMonic(){
        // Divides the polynomial with the leading coefficient to make the polynomial monic
        let l = self.leadingCoeff

        for (idx, coeff) in self.coeffs.enumerated() {
            self.coeffs[idx] = coeff / l
        }
        
    }
    
    private func companionMatrix() throws -> [__CLPK_doublereal] {
        if !self.monic { throw PolyError.notMonicError("Polynomial has to be monic to form companion matrix!") }
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
    
    
    func roots() throws -> [Complex] {
        let cpy = self.monicCopy()
        var roots = [Complex]()
        let eigenvalues = try cpy.eigenvalues()
        for (real, img) in zip(eigenvalues.0, eigenvalues.1){
            roots.append(Complex(real: real, img: img))
        }
        
        return roots
    }
    
    public func realRoots() throws -> [Double] {
        let cpy = self.monicCopy()
        var realRoots = [Double]()
        let eigenvalues = try cpy.eigenvalues()
        for (real, img) in zip(eigenvalues.0, eigenvalues.1){
            if img == 0{
                realRoots.append(real)
            }
        }
        
        return realRoots
    }
    
    
    public func positiveRoots() throws -> [Double] {
        let realRoots = try self.realRoots()
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
        var ldvl = N
        var ldvr = N
        

        var error : __CLPK_integer = 0
        var lwork = __CLPK_integer(-1)
        // Real parts of eigenvalues
        var wr = [Double](repeating: 0, count: Int(N))
        // Imaginary parts of eigenvalues
        var wi = [Double](repeating: 0, count: Int(N))
        // Left eigenvectors
        var vl = [__CLPK_doublereal](repeating: 0, count: Int(N*N))
        // Right eigenvectors
        var vr = [__CLPK_doublereal](repeating: 0, count: Int(N*N))

        let JOBVL = UnsafeMutablePointer(mutating: ("V" as NSString).utf8String)
        let JOBVR = UnsafeMutablePointer(mutating: ("V" as NSString).utf8String)
        
        // Query for workspace
        var workspaceQuery: Double = 0.0
        
        dgeev_(JOBVL, JOBVR, &N, &V, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &workspaceQuery, &lwork, &error)
        // size workspace per the results of the query:
        var workspace = [Double](repeating: 0, count: Int(workspaceQuery))
        lwork = __CLPK_integer(workspaceQuery)
        
        dgeev_(JOBVL, JOBVR, &N, &V, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &workspace, &lwork, &error)

        if error != 0 {
            throw PolyError.eigenvalueError("Failed to compute eigenvalues!")
        }
        return (wr, wi)

    }
    
}
