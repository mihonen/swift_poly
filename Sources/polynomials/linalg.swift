//
//  File.swift
//  
//
//  Created by Ville Muhonen on 21.1.2023.
//

import Foundation
import Accelerate

extension Polynomial {
    
    
    
    private func companionMatrix() throws -> [__CLPK_doublereal] {
        if !self.monic { throw PolyError.notMonicError("Polynomial has to be monic to form companion matrix!") }
        let n = self.degree()
        if n == 0 { return [Double]() }
        
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
    
    
    public func eigenvalues() throws -> ([Double], [Double]) {
        // Calculates the eigenvalues of the companion matrix using LAPACK and dgeev_
        // https://netlib.org/lapack/explore-html/d9/d8e/group__double_g_eeigen_ga66e19253344358f5dee1e60502b9e96f.html
        // returns two arrays A and B, A holds the real parts and B the imaginary parts
        if self.degree() == 0 {
            return ([Double](), [Double]())
        }
        
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

        let JOBVL = UnsafeMutablePointer(mutating: ("N" as NSString).utf8String)
        let JOBVR = UnsafeMutablePointer(mutating: ("N" as NSString).utf8String)
        
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
