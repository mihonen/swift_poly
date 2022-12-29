//
//  File.swift
//  
//
//  Created by Ville Muhonen on 29.12.2022.
//

import Foundation


// Because of floating point errors,
// results should be rounded to some number of decimal places
// to perform precise arithmetics
// ==============================
// FURTHER INFO:
// https://en.wikipedia.org/wiki/Floating-point_arithmetic
// https://www.geeksforgeeks.org/floating-point-error-in-python/

let roundingDecimalPlaces: Int = 9

func Round(value: Double) -> Double {
    let n = pow(10.0, Double(roundingDecimalPlaces))
    let rounded = Double(round(n * value) / n)
    return rounded
}




// Complex Round
func RoundC(z: Complex) -> Complex {
    let n = pow(10.0, Double(roundingDecimalPlaces))
    let roundedA = Double(round(n * z.real) / n)
    let roundedB = Double(round(n * z.img) / n)

    return Complex(real: roundedA, img: roundedB)
}
