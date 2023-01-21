//
//  File.swift
//  
//
//  Created by Ville Muhonen on 21.1.2023.
//

import Foundation



extension Polynomial{
    
    func rootsQuadratic() throws -> [Complex]{
        if self.degree() != 2 { throw PolyError.notQuadraticError("cannot use quatratic formula on non-quatratic polynomial") }

        let a = self.coeffs[0]
        let b = self.coeffs[1]
        let c = self.coeffs[2]

        let discriminant = b*b - 4.0*a*c
        if discriminant == 0 {

            let x = (-b) / (2.0*a)
            return [Complex(real: x, img: 0)]

        } else if discriminant > 0 {

            let x1 = (-b + sqrt(discriminant) ) / (2.0*a)
            let x2 = (-b - sqrt(discriminant) ) / (2.0*a)
            return [Complex(real: x1, img: 0), Complex(real: x2, img: 0)]

        } else { // complex
            let realPart = -b / (2.0*a)
            let imgPart  = sqrt(-discriminant) / (2.0*a)
            let root1 = Complex(real: realPart, img: +imgPart)
            let root2 = Complex(real: realPart, img: -imgPart)


            return [root1, root2]
        }

    }
    
    
}
