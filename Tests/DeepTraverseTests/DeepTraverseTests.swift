import XCTest
import DeepTraverse

final class DeepTraverseTests: XCTestCase {
    func testTraversal() {
        let levelThree: [Any] = [true, false]
        let levelTwo: [String: Any] = ["nested": levelThree]
        let levelOne: [String: Any] = ["top": levelTwo]
        
        XCTAssertEqual(levelOne.deepGet("top", "nested", 0) as? Bool, true)
        XCTAssertEqual(levelOne.deepGet("top", "nested", 1) as? Bool, false)
        
        // Looking up index out of range
        XCTAssertNil(levelOne.deepGet("top", "nested", 2))
        
        // Looking up non-existent stuff
        XCTAssertNil(levelOne.deepGet("top", "nested", "nonexistent", 2))
    }


    static var allTests = [
        ("testTraversal", testTraversal),
    ]
}
