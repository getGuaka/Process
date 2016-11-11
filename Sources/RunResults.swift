//
//  RunResult.swift
//  RunResults
//
//  Created by Omar Abdelhafith on 05/11/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//


/**
 *  Structure to hold results from run
 */
public struct RunResults {
  
  /// Command exit status
  public let exitStatus: Int
  
  /// Command output stdout
  public let stdout: String
  
  /// Command output stderr
  public let stderr: String
}

// MARK:- Internal

func splitCommandToArgs(_ command: String) -> [String] {
  
  if command.characters.contains(" ") {
    // TODO: FIX
    return [""] //command.components(separatedBy: " ")
  }
  
  return [command]
}

func read(pipe: TaskIO) -> String {
  let s: String = (try? pipe.read()) ?? ""
  return s
}
