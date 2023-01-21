



import Foundation



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
    
    
}
