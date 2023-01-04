import XCTest
@testable import polynomials

final class polynomialsTests: XCTestCase {
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(Polynomial().text, "Hello, World!")
//    }
    
    
    
    func testPolynomial(){
        let poly = Polynomial(coefficients: 1.0, 3.3, -2.0)
        XCTAssertEqual(poly.monic,  true)
    }
    
    
    func testRealRoots() throws {
        
        let poly = Polynomial(coefficients: 1.0, 4.2, -2.1, 1.111)
        let realRoots = [-4.697405158]
        let foundRoots = try poly.realRoots()
        
        XCTAssertEqual(Round(value: foundRoots[0]),  realRoots[0])
    }
    
    func testComplexRoots() throws {
        
        var poly = Polynomial(coefficients: 0.0004, 0.011042681, 0.077423224, 0.005671027, -0.000125438)
        let sol1 = Complex(real: 0.01778822159056967, img: 0)
        let sol2 = Complex(real: -0.09205210672114453,img:  0)
        let sol3 = Complex(real: -13.766219307434705, img: 1.4164171575579814)
        let sol4 = Complex(real: -13.766219307434705, img: -1.4164171575579814)
        
        var allSolutions = [sol1, sol2, sol3, sol4]
        
        let foundRoots = try poly.roots()
        
        for foundRoot in foundRoots {
            for (idx, solution) in allSolutions.enumerated() {
                if RoundC(z: solution) == RoundC(z: foundRoot) {
                    allSolutions.remove(at: idx)
                    break
                }
            }
        }
        
        
        XCTAssertEqual(allSolutions.count, 0)
    }
    
    func testWithLeadingZeros() throws {
        let poly = Polynomial(coefficients: 0, 0, 1.2, 4.4, -23)
        let sol1 = Complex(real: 2.913010288632714, img: 0)
        let sol2 = Complex(real: -6.579676955299381,img:  0)
        var allSolutions = [sol1, sol2]

        let foundRoots = try poly.roots()
        
        for foundRoot in foundRoots {
            for (idx, solution) in allSolutions.enumerated() {
                if RoundC(z: solution) == RoundC(z: foundRoot) {
                    allSolutions.remove(at: idx)
                    break
                }
            }
        }
        
        
        XCTAssertEqual(allSolutions.count, 0)
    }
    
    
    
    func testBug() throws {
        let a = 0.0
        let b = 0.0
        let c = 0.3020537512176589
        let d = -0.5198799754928999
        let e = 0.2543260291593869
        
        
        for _ in 0...10 {
            let poly = Polynomial(coefficients: a, b, c, d, e)
            
            let roots = try poly.positiveRoots()
            print(roots)
        }
    }
    
}
