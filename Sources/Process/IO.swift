//
//  IO.swift
//  Run
//
//  Created by Omar Abdelhafith on 11/11/2016.
//
//

#if os(Linux)
  @_exported import Glibc
#else
  @_exported import Darwin.C
#endif


/// Structurs that represents an IO device
/// It wraps a file descriptor and provide functions to deal with it
struct IO: TaskIO {
  let fd: FileDescriptor
}

// MARK: - Reading
extension IO {
  func read() throws -> String {
    return try _readToString(fd: fd)
  }
  
  func read(length: Int) throws -> [UInt8]? {
    return try _read(fd: fd, length: length)
  }
  
  func read() throws -> [UInt8] {
    return try _read(fd: fd)
  }
  
}


// MARK: - Closing
extension IO {
  func close() throws {
    try _close(fd: fd)
  }
}


/// MARK: Private

func retryInterrupt<T>(block: () throws -> T) throws -> T {
  return try retryInterrupt(block: block())
}

func retryInterrupt<T>( block: @autoclosure () throws -> T) throws -> T {
  while true {
    do {
      return try block()
    } catch is SystemError where errno == EINTR {
      continue
    }
  }
}

private func _read(fd: FileDescriptor, length: Int) throws -> [UInt8]? {
  var buf = [UInt8](repeating: 0, count: length)
  return try retryInterrupt {

    #if os(Linux)
      let n = Glibc.read(fd, &buf, length)
    #else
      let n = Darwin.read(fd, &buf, length)
    #endif

    switch n {
    case -1:
      throw SystemError.read(errno)
    case 0:
      return nil
    default:
      return Array(buf[0..<n])
    }
  }
}

private func _read(fd: FileDescriptor) throws -> [UInt8] {
  var buf = [UInt8]()
  while let chunk = try _read(fd: fd, length: 4096) {
    buf.append(contentsOf: chunk)
  }
  try _close(fd: fd)
  return buf
}

private func _readToString(fd: FileDescriptor) throws -> String {
  let data = try _read(fd: fd)
  if data.count == 0 { return "" }
  
  let str = String.init(cString: data.map({ UInt8($0)}))
  return str
}

private func _close(fd: FileDescriptor) throws {
  let rv = close(fd)
  guard rv == 0 else {
    throw SystemError.close(rv)
  }
}
