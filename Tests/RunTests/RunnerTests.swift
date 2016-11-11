import XCTest
@testable import Run


class RunnerTests: XCTestCase {
  
  var promptPrinter: DummyPromptPrinter!
  
  override func setUp() {
    promptPrinter = DummyPromptPrinter()
    PromptSettings.printer = promptPrinter 
  }
  
  
  func testItExecutesACommandWithDummyExecutor() {
    var dummyExecutor: DummyTaskExecutor!
    
    dummyExecutor = DummyTaskExecutor(status: 0, output: "123", error: "")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    let res = 🏃.run("ls -all")
    
    XCTAssertEqual(res.exitStatus, 0)
    XCTAssertEqual(res.stdout, "123")
    XCTAssertEqual(res.stderr, "123")
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
  }
  
//  func testItExecutesACommanAndHandlesErrorsdWithDummyExecutor() {
//    var dummyExecutor: DummyTaskExecutor!
//    
//    dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "123")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    let res = 🏃.run("test test test")
//    
//    expect(res.exitStatus).to(equal(1))
//    expect(res.stdout).to(equal(""))
//    expect(res.stderr).to(equal("123"))
//    
//    expect(dummyExecutor.commandsExecuted).to(equal(["test test test"]))
//  }
//  
//  func testItExecutesACommanWithSeparatedArgsWithDummyExecutor() {
//    var dummyExecutor: DummyTaskExecutor!
//    
//    dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "123")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls", args: ["-all"])
//    expect(dummyExecutor.commandsExecuted).to(equal(["ls -all"]))
//    
//    🏃.run("echo", args: "bbb")
//    expect(dummyExecutor.commandsExecuted).to(equal(["ls -all", "echo bbb"]))
//  }
//  
//  
//  func testItEchosBackStdoutAndStderr() {
//    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was", error: "error out")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls", args: ["-all"]) { s in
//      s.echo = [.Stdout, .Stderr]
//    }
//    
//    expect(dummyExecutor.commandsExecuted).to(equal(["ls -all"]))
//    
//    let output = [
//      "Stdout: ",
//      "Command output was",
//      "Stderr: ",
//      "error out\n"].joined(separator: "\n")
//    expect(promptPrinter.printed).to(equal(output))
//  }
//  
//  
//  func testItDoesNotEchoIfEmpty() {
//    let dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "error out")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls", args: ["-all"]) { s in
//      s.echo = [.Stdout, .Stderr]
//    }
//    
//    expect(dummyExecutor.commandsExecuted).to(equal(["ls -all"]))
//    
//    let output = [
//      "Stderr: ",
//      "error out\n"].joined(separator: "\n")
//    expect(promptPrinter.printed).to(equal(output))
//  }
//  
//  func testICanEchoOnlyTheCommand() {
//    let dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "error out")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls", args: ["-all"]) { s in
//      s.echo = .Command
//    }
//    
//    expect(dummyExecutor.commandsExecuted).to(equal(["ls -all"]))
//    
//    let output = [
//      "Command: ",
//      "ls -all\n"].joined(separator: "\n")
//    expect(promptPrinter.printed).to(equal(output))
//  }
//  
//  func testItEchosStdoOutOnly() {
//    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls") {
//      $0.echo = .Stdout
//    }
//    
//    let output = [
//      "Stdout: ",
//      "Command output was 2\n"].joined(separator: "\n")
//    expect(promptPrinter.printed).to(equal(output))
//  }
//  
//  func testItEchosStderrtOnly() {
//    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls") {
//      $0.echo = .Stderr
//    }
//    
//    let output = [
//      "Stderr: ",
//      "error out 2\n"].joined(separator: "\n")
//    expect(promptPrinter.printed).to(equal(output))
//  }
//  
//  func testItCanEchoBackNothing() {
//    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls") {
//      $0.echo = .None
//    }
//    
//    expect(promptPrinter.printed).to(equal("")) 
//  }
//  
//  func testItCanEchoBackTheCommandOnly() {
//    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
//    CommandExecutor.currentTaskExecutor = dummyExecutor
//    
//    🏃.run("ls -all", echo: [.Command])
//    
//    expect(dummyExecutor.commandsExecuted).to(equal(["ls -all"]))
//    
//    let output = [
//      "Command: ",
//      "ls -all\n"].joined(separator: "\n")
//    expect(promptPrinter.printed).to(equal(output))
//  }
//  
//  
//  func testItExecuteLS() {
//    CommandExecutor.currentTaskExecutor = ActualTaskExecutor()
//    let res = 🏃.run("ls -all")
//    
//    expect(res.exitStatus).to(equal(0))
//    expect(res.stdout).notTo(equal(""))
//    expect(res.stderr).to(equal(""))
//  }
//  
//  func testItDryExecutesLS() {
//    CommandExecutor.currentTaskExecutor = ActualTaskExecutor()
//    let res = 🏃.run("ls -all") {
//      $0.dryRun = true
//    }
//    
//    expect(res.exitStatus).to(equal(0))
//    expect(res.stdout).to(equal(""))
//    expect(res.stderr).to(equal(""))
//    expect(promptPrinter.printed).to(equal("Executed command 'ls -all'\n"))
//  }
//  
//  func testItCanDoInteractiveExecutions() {
//    CommandExecutor.currentTaskExecutor = InteractiveTaskExecutor()
//    let res = 🏃.runWithoutCapture("ls")
//    
//    // Make it pass for now
//    // FIXME: figure out why this does not work
//    expect(res).to(equal(2))
//  }
}
