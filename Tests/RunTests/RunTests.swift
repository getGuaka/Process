import XCTest
@testable import Run

class RunTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    Run()
    let x = 🏃.run("echo", args: ["1", "2", "3"])
    print(x)
  }
  
  
  static var allTests : [(String, (RunTests) -> () throws -> Void)] {
    return [
      ("testExample", testExample),
    ]
  }
}
