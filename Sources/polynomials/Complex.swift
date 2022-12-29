//
//  File.swift
//  
//
//  Created by Ville Muhonen on 29.12.2022.
//

import Foundation



struct Complex {
    var real: Double
    var img: Double
    
    init(real: Double, img: Double){
        self.real = real
        self.img = img
    }
    
    static func == (lhs: Complex, rhs: Complex) -> Bool {
        return lhs.real == rhs.real && lhs.img == rhs.img
    }
    
}
