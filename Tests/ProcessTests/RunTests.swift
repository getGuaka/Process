import XCTest
@testable import Process

class RunTests: XCTestCase {
  func testExample() {
    let x = Process.exec("rbenv")
    print(x)
  }
  
  
  static var allTests : [(String, (RunTests) -> () throws -> Void)] {
    return [
      ("testExample", testExample),
    ]
  }
}
