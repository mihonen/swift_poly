//
//  File.swift
//  
//
//  Created by Ville Muhonen on 21.1.2023.
//

import Foundation



extension Polynomial {
    
    
    func roots() throws -> [Complex] {
        let roots: [Complex]
        
        if self.degree() == 2 {
            roots = try rootsQuadratic()
        }
        else {
            roots = try rootsEigenvalue()
            
        }
        
        return roots
    }
    

    public func realRoots() throws -> [Double] {
        let cpy = self.monicCopy()
        var realRoots = [Double]()
        let roots = try cpy.roots()
        
        for root in roots {
            if root.img == 0{
                realRoots.append(root.real)
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
    
    
    func rootsEigenvalue() throws -> [Complex]{
        let cpy = self.monicCopy()
        var roots = [Complex]()
        let eigenvalues = try cpy.eigenvalues()
        for (real, img) in zip(eigenvalues.0, eigenvalues.1){
            roots.append(Complex(real: real, img: img))
        }
        
        return roots
    }
    

}
