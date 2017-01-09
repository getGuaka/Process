//
//  SystemError.swift
//  Run
//
//  Created by Omar Abdelhafith on 11/11/2016.
//
//

/// System errors
///
/// - close:       error closing descriptor
/// - pipe:        error creating pip
/// - posix_spawn: error in spawing 
/// - read:        error reading descriptor
/// - select:      error during descriptor selection
/// - waitpid:     error when waiting pid
public enum SystemError: Error {
  case close(Int32)
  case pipe(Int32)
  case posix_spawn(Int32)
  case read(Int32)
  case select(Int32)
  case waitpid(Int32)
}
