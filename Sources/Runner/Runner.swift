//
//  Runner.swift
//  🏃
//
//  Created by Omar Abdelhafith on 02/11/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//


enum 🏃{
  
  static func runWithoutCapture(_ command: String) -> Int {
    let initalSettings = RunSettings()
    return run(command, settings: initalSettings).exitStatus
  }
  
  static func run(_ command: String) -> RunResults {
    let settings = RunSettings()
    return run(command, settings: settings)
  }
  
  static func run(_ command: String, settings: ((RunSettings) -> Void)) -> RunResults {
    let initalSettings = RunSettings()
    settings(initalSettings)
    
    return run(command, settings: initalSettings)
  }
  
  static func run(_ command: String, echo: EchoSettings) -> RunResults {
    let initalSettings = RunSettings()
    initalSettings.echo = echo
    return run(command, settings: initalSettings)
  }
  
  static func run(_ command: String, settings: RunSettings) -> RunResults {
        
    let result: RunResults
    
    echoCommand(command, settings: settings)
    
    if settings.dryRun {
      result = executeDryCommand(command)
    } else {
      result = executeActualCommand(command)
    }
    
    echoResult(result, settings: settings)
    
    return result
  }
  
  fileprivate static func executeDryCommand(_ command: String) -> RunResults {
    return execute(command, withExecutor: DryTaskExecutor())
  }

  
  fileprivate static func executeActualCommand(_ command: String) -> RunResults {
    return execute(command, withExecutor: CommandExecutor.currentTaskExecutor)
  }
  
  fileprivate static func execute(_ command: String, withExecutor executor: TaskExecutor) -> RunResults {
    let (status, stdoutPipe, stderrPipe) = executor.execute(command)!
    
    let stdout = read(pipe: stdoutPipe)
    let stderr = read(pipe: stderrPipe)
    return RunResults(exitStatus: status, stdout: stdout, stderr: stderr)
  }
  
  fileprivate static func echoCommand(_ command: String, settings: RunSettings) {
    if settings.echo.contains(.Command) {
      echoStringIfNotEmpty("Command", string: command)
    }
  }
  
  fileprivate static func echoResult(_ result: RunResults, settings: RunSettings) {
    if settings.echo.contains(.Stdout) {
      echoStringIfNotEmpty("Stdout", string: result.stdout)
    }
    
    if settings.echo.contains(.Stderr) {
      echoStringIfNotEmpty("Stderr", string: result.stderr)
    }
  }
  
  fileprivate static func echoStringIfNotEmpty(_ title: String, string: String) {
    if !string.isEmpty {
      PromptSettings.print("\(title): \n\(string)")
    }
  }
}
