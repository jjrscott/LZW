import XCTest
@testable import LZW

final class LZWTests: XCTestCase {
    
    func testClassic() throws {
        let original = "TOBEORNOTTOBEORTOBEORNOT"
        let compressed = LZW.compress(original.utf8.map({$0})).map { unit in
            switch unit {
            case .element(let value):
                return UInt(value)
            case .index(let index):
                return UInt(UInt8.max) + UInt(index)
            }
        }
        XCTAssertEqual(compressed, [84, 79, 66, 69, 79, 82, 78, 79, 84, 255, 257, 259, 264, 258, 260, 262])
    }
    
    
    func testStrings() throws {
        
        func test(original: String) throws {
            let compressed = LZW.compress(original.utf8.map({$0}))
            let decompressed = String(decoding: try LZW.decompress(compressed), as: UTF8.self)
            XCTAssertEqual(original, decompressed)
        }

        try test(original: "TOBEORNOTTOBEORTOBEORNOT")
        try test(original: "TOBEORNOTTOBEORTOBEORNOTOTOTO")
        try test(original: "ABCABF")
        try test(original: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        try test(original: "")
    }
    
    func testNumbers() throws {
        
        func test<T>(value: [T], compressedValue: [LZW.Unit<T>]) throws {
            let compressed = LZW.compress(value)
            XCTAssertEqual(compressed, compressedValue)
            let decompressed = try LZW.decompress(compressed)
            XCTAssertEqual(value, decompressed)
        }
        
        try test(value: [10, 10, 20, -40, 10, 10, 9, 35, 10],
                 compressedValue: [.element(10), .element(10), .element(20), .element(-40), .index(0), .element(9), .element(35), .element(10)])
        
        try test(value: [5, 3, 0, 1, 3, 4, 2, 3, 5, 5, 3, 0, 1, 3, 4, 5, 3, 0, 1, 3, 4, 2, 3, 5, 3, 5, 3, 5, 3],
                 compressedValue: [.element(5), .element(3), .element(0), .element(1), .element(3), .element(4), .element(2), .element(3), .element(5), .index(0), .index(2), .index(4), .index(9), .index(3), .index(5), .index(7), .index(15), .index(0)])
        
        try test(value: [Float](), compressedValue: [LZW.Unit<Float>]())
    }
    
    func testCorrupted() throws {
        func test(compressedValue: [LZW.Unit<Int>]) throws {
            XCTAssertThrowsError(try LZW.decompress(compressedValue))
        }

        try test(compressedValue: [.element(10), .index(1)])
        try test(compressedValue: [.index(0)])
    }
}
