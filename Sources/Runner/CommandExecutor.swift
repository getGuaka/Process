//
//  CommandExecutor.swift
//  CommandExecutor
//
//  Created by Omar Abdelhafith on 05/11/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//
import RunnerEnviron

typealias ExecutorReturnValue = (status: Int, standardOutput: TaskIO, standardError: TaskIO)

class CommandExecutor {
  
  static var currentTaskExecutor: TaskExecutor = ActualTaskExecutor()
  
  class func execute(_ command: String) -> ExecutorReturnValue {
    return currentTaskExecutor.execute(command)!
  }
}


protocol TaskExecutor {
  func execute(_ command: String) -> ExecutorReturnValue?
}

class DryTaskExecutor: TaskExecutor {
  
  func execute(_ command: String) -> ExecutorReturnValue? {
    PromptSettings.print("Executed command '\(command)'")
    
    return (0,
            DryIO(stringToReturn: ""),
            DryIO(stringToReturn: ""))
  }
}

class ActualTaskExecutor: TaskExecutor {
  
  func execute(_ command: String) -> ExecutorReturnValue?  {
    let (stdOut, outW) = try! pipe()
    let (stdErr, errW) = try! pipe()
    
    let process = try! spawn(["/bin/sh", "-c", command],
                             environment: environment, fileActions: [
      .Dup2(outW.fd, 1),
      .Dup2(errW.fd, 2),
      .Close(stdOut.fd),
      .Close(stdErr.fd),
      ])
    
    do {
      try outW.close()
      try errW.close()
      let status = try process.wait()
      
      return (status: status.exitstatus, standardOutput: stdOut, standardError: stdErr)
    } catch {
      return nil
    }
  }
}

class DummyTaskExecutor: TaskExecutor {
  
  var commandsExecuted: [String] = []
  let statusCodeToReturn: Int
  
  let errorToReturn: String
  let outputToReturn: String
  
  init(status: Int, output: String, error: String) {
    statusCodeToReturn = status
    outputToReturn = output
    errorToReturn = error
  }
  
  func execute(_ command: String) -> ExecutorReturnValue? {
    commandsExecuted.append(command)
    
    return (statusCodeToReturn,
            DryIO(stringToReturn: outputToReturn),
            DryIO(stringToReturn: errorToReturn))
  }
}

var environment: [String] {
  
  var items: [String] = []
  guard var environCopy = environ else { return items }
  
  while true {
    let x = environCopy[0]
    
    guard
      let environment = x
      else { return items }
    
    let environmentStr = String(cString: environment)
    items.append(environmentStr)
    
    environCopy = environCopy.advanced(by: 1)
  }
}
