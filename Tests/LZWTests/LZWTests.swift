import XCTest
@testable import LZW

final class LZWTests: XCTestCase {
    func testExample() throws {
        
        let original = "TOBEORNOTTOBEORTOBEORNOT"
        
        let compressed = try LZW.compress(original)
        
        let decompressed = try XCTUnwrap(LZW.decompress(compressed))

        XCTAssertEqual(original, decompressed)
    }
}
