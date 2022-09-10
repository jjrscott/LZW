import XCTest
@testable import LZW

func compressString(_ uncompressed: String) -> [LZW.Unit<String.UTF8View.Element>] {
    return LZW.compress(uncompressed.utf8.map({$0}))
}

func decompressString(_ compressed: [LZW.Unit<String.UTF8View.Element>]) throws -> String {
    return String(decoding: try LZW.decompress(compressed), as: UTF8.self)
}

final class LZWTests: XCTestCase {
    func testExample() throws {
        
        let original = "TOBEORNOTTOBEORTOBEORNOT"
        
        let compressed = compressString(original)
        
        let decompressed = try XCTUnwrap(decompressString(compressed))

        XCTAssertEqual(original, decompressed)
    }
}
