import XCTest
@testable import Process


class ProcessTests: XCTestCase {
  
  var promptPrinter: DummyPromptPrinter!
  
  override func setUp() {
    promptPrinter = DummyPromptPrinter()
    PromptSettings.printer = promptPrinter 
  }
  
  
  func testItExecutesACommandWithDummyExecutor() {
    var dummyExecutor: DummyTaskExecutor!
    
    dummyExecutor = DummyTaskExecutor(status: 0, output: "123", error: "")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    let res = Process.exec("ls -all")
    
    XCTAssertEqual(res.exitStatus, 0)
    XCTAssertEqual(res.stdout, "123")
    XCTAssertEqual(res.stderr, "")
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
  }
  
  func testItExecutesACommanAndHandlesErrorsdWithDummyExecutor() {
    var dummyExecutor: DummyTaskExecutor!
    
    dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "123")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    let res = Process.exec("test test test")
    
    XCTAssertEqual(res.exitStatus, 1)
    XCTAssertEqual(res.stdout, "")
    XCTAssertEqual(res.stderr, "123")
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["test test test"])
  }
  
  func testItEchosBackStdoutAndStderr() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was", error: "error out")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = Process.exec("ls -all") { s in
      s.echo = [.Stdout, .Stderr]
    }
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    
    let output = [
      "Stdout: ",
      "Command output was",
      "Stderr: ",
      "error out\n"].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testItDoesNotEchoIfEmpty() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "error out")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = Process.exec("ls -all") { s in
      s.echo = [.Stdout, .Stderr]
    }
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    
    let output = [
      "Stderr: ",
      "error out\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testICanEchoOnlyTheCommand() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "error out")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = Process.exec("ls -all") { s in
      s.echo = .Command
    }
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    
    let output = [
      "Command: ",
      "ls -all\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testItEchosStdoOutOnly() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = Process.exec("ls") {
      $0.echo = .Stdout
    }
    
    let output = [
      "Stdout: ",
      "Command output was 2\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testItEchosStderrtOnly() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = Process.exec("ls") {
      $0.echo = .Stderr
    }
    
    let output = [
      "Stderr: ",
      "error out 2\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
    func testItCanEchoBackNothing() {
      let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
      CommandExecutor.currentTaskExecutor = dummyExecutor
      
      _ = Process.exec("ls") {
        $0.echo = .None
      }
      
      XCTAssertEqual(promptPrinter.printed, "")
    }
    
    func testItCanEchoBackTheCommandOnly() {
      let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
      CommandExecutor.currentTaskExecutor = dummyExecutor
      
      _ = Process.exec("ls -all", echo: [.Command])
      
      XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
      
      let output = [
        "Command: ",
        "ls -all\n"].joined(separator: "\n")
      XCTAssertEqual(promptPrinter.printed, output)
    }
        
    func testItExecuteLS() {
      CommandExecutor.currentTaskExecutor = ActualTaskExecutor()
      let res = Process.exec("ls -all")
      
      XCTAssertEqual(res.exitStatus, 0)
      XCTAssertNotEqual(res.stdout, "")
      XCTAssertEqual(res.stderr, "")
    }
    
    func testItDryExecutesLS() {
      
      CommandExecutor.currentTaskExecutor = ActualTaskExecutor()
      let res = Process.exec("ls -all") {
        $0.dryRun = true
      }
      
      XCTAssertEqual(res.exitStatus, 0)
      XCTAssertEqual(res.stdout, "")
      XCTAssertEqual(res.stderr, "")
      XCTAssertEqual(promptPrinter.printed, "Executed command 'ls -all'\n")
    }
    
}
