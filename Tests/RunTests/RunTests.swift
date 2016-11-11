import XCTest
@testable import Run

class RunTests: XCTestCase {
  func testExample() {
    let x = 🏃.run("rbenv")
    print(x)
  }
  
  
  static var allTests : [(String, (RunTests) -> () throws -> Void)] {
    return [
      ("testExample", testExample),
    ]
  }
}
