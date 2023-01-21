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
        let realRoots = [-4.697405158313411]
        let foundRoots = try poly.realRoots()
        
        XCTAssertEqual(Round(value: foundRoots[0]),  Round(value: realRoots[0]))
    }
    
    func testComplexRoots() throws {
        
        let poly = Polynomial(coefficients: 0.0004, 0.011042681, 0.077423224, 0.005671027, -0.000125438)
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
    func testQuadratic() throws {
        let a = -3.0
        let b =  1.33
        let c = -2.5

        let solution1 = Complex(real: 0.22166666666666, img: -0.88554910774176)
        let solution2 = Complex(real: 0.22166666666666, img: +0.88554910774176)
        
        

        let test_poly = Polynomial(coefficients: a, b, c)

        let roots = try test_poly.roots()
        




        XCTAssertEqual(roots.count,  2)
        XCTAssertEqual(RoundC(z: roots[0]),  RoundC(z: solution1))
        XCTAssertEqual(RoundC(z: roots[1]),  RoundC(z: solution2))

    }
    
}



