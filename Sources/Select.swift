#if os(Linux)
  @_exported import Glibc
#else
  @_exported import Darwin.C
#endif


/// Select loop for reading
///
/// - parameter readFds:  read file descriptors
/// - parameter writeFds: write file descriptors
/// - parameter errorFds: write error descriptors
/// - parameter timeout:  timeout
func select(readFds: Set<FileDescriptor> = [], 
            writeFds: Set<FileDescriptor> = [], 
            errorFds: Set<FileDescriptor> = [], 
            timeout: Float? = nil) 
  throws -> (Set<FileDescriptor>, Set<FileDescriptor>, Set<FileDescriptor>) {
    var nfds: Int32 = 0
    var readfds = fd_set()
    var writefds = fd_set()
    var errorfds = fd_set()
    
    return try retryInterrupt {
      fdZero(set: &readfds)
      fdZero(set: &writefds)
      fdZero(set: &errorfds)
      
      for fd in readFds {
        nfds = max(nfds, fd) + 1
        fdSet(fd: fd, set: &readfds)
      }
      
      for fd in writeFds {
        nfds = max(nfds, fd) + 1
        fdSet(fd: fd, set: &writefds)
      }
      
      for fd in errorFds {
        nfds = max(nfds, fd) + 1
        fdSet(fd: fd, set: &errorfds)
      }
      
      let rv: Int32
      if let timeout = timeout {
        var tv = timeval(tv_sec: Int(timeout), tv_usec: 0)
        rv = select(nfds, &readfds, &writefds, &errorfds, &tv)
      } else {
        rv = select(nfds, &readfds, &writefds, &errorfds, nil)
      }
      
      guard rv != -1 else {
        throw SystemError.select(errno)
      }
      
      var readyReadFds: Set<FileDescriptor> = []
      var readyWriteFds: Set<FileDescriptor> = []
      var readyErrorFds: Set<FileDescriptor> = []
      
      for fd in readFds {
        if fdIsSet(fd: fd, set: &readfds) {
          readyReadFds.insert(fd)
        }
      }
      
      for fd in writeFds {
        if fdIsSet(fd: fd, set: &writefds) {
          readyWriteFds.insert(fd)
        }
      }
      
      for fd in errorFds {
        if fdIsSet(fd: fd, set: &errorfds) {
          readyErrorFds.insert(fd)
        }
      }
      
      return (readyReadFds, readyWriteFds, readyErrorFds)
    }
}

private func fdZero( set: inout fd_set) {
  set.fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
}

private func fdSet(fd: Int32, set: inout fd_set) {
  let intOffset = Int(fd / 32)
  let bitOffset = fd % 32
  let mask = 1 << bitOffset
  switch intOffset {
  case 0: set.fds_bits.0 = set.fds_bits.0 | mask
  case 1: set.fds_bits.1 = set.fds_bits.1 | mask
  case 2: set.fds_bits.2 = set.fds_bits.2 | mask
  case 3: set.fds_bits.3 = set.fds_bits.3 | mask
  case 4: set.fds_bits.4 = set.fds_bits.4 | mask
  case 5: set.fds_bits.5 = set.fds_bits.5 | mask
  case 6: set.fds_bits.6 = set.fds_bits.6 | mask
  case 7: set.fds_bits.7 = set.fds_bits.7 | mask
  case 8: set.fds_bits.8 = set.fds_bits.8 | mask
  case 9: set.fds_bits.9 = set.fds_bits.9 | mask
  case 10: set.fds_bits.10 = set.fds_bits.10 | mask
  case 11: set.fds_bits.11 = set.fds_bits.11 | mask
  case 12: set.fds_bits.12 = set.fds_bits.12 | mask
  case 13: set.fds_bits.13 = set.fds_bits.13 | mask
  case 14: set.fds_bits.14 = set.fds_bits.14 | mask
  case 15: set.fds_bits.15 = set.fds_bits.15 | mask
  case 16: set.fds_bits.16 = set.fds_bits.16 | mask
  case 17: set.fds_bits.17 = set.fds_bits.17 | mask
  case 18: set.fds_bits.18 = set.fds_bits.18 | mask
  case 19: set.fds_bits.19 = set.fds_bits.19 | mask
  case 20: set.fds_bits.20 = set.fds_bits.20 | mask
  case 21: set.fds_bits.21 = set.fds_bits.21 | mask
  case 22: set.fds_bits.22 = set.fds_bits.22 | mask
  case 23: set.fds_bits.23 = set.fds_bits.23 | mask
  case 24: set.fds_bits.24 = set.fds_bits.24 | mask
  case 25: set.fds_bits.25 = set.fds_bits.25 | mask
  case 26: set.fds_bits.26 = set.fds_bits.26 | mask
  case 27: set.fds_bits.27 = set.fds_bits.27 | mask
  case 28: set.fds_bits.28 = set.fds_bits.28 | mask
  case 29: set.fds_bits.29 = set.fds_bits.29 | mask
  case 30: set.fds_bits.30 = set.fds_bits.30 | mask
  case 31: set.fds_bits.31 = set.fds_bits.31 | mask
  default: break
  }
}

private func fdIsSet(fd: Int32, set: inout fd_set) -> Bool {
  let intOffset = Int(fd / 32)
  let bitOffset = fd % 32
  let mask = 1 << bitOffset
  switch intOffset {
  case 0: return set.fds_bits.0 & mask != 0
  case 1: return set.fds_bits.1 & mask != 0
  case 2: return set.fds_bits.2 & mask != 0
  case 3: return set.fds_bits.3 & mask != 0
  case 4: return set.fds_bits.4 & mask != 0
  case 5: return set.fds_bits.5 & mask != 0
  case 6: return set.fds_bits.6 & mask != 0
  case 7: return set.fds_bits.7 & mask != 0
  case 8: return set.fds_bits.8 & mask != 0
  case 9: return set.fds_bits.9 & mask != 0
  case 10: return set.fds_bits.10 & mask != 0
  case 11: return set.fds_bits.11 & mask != 0
  case 12: return set.fds_bits.12 & mask != 0
  case 13: return set.fds_bits.13 & mask != 0
  case 14: return set.fds_bits.14 & mask != 0
  case 15: return set.fds_bits.15 & mask != 0
  case 16: return set.fds_bits.16 & mask != 0
  case 17: return set.fds_bits.17 & mask != 0
  case 18: return set.fds_bits.18 & mask != 0
  case 19: return set.fds_bits.19 & mask != 0
  case 20: return set.fds_bits.20 & mask != 0
  case 21: return set.fds_bits.21 & mask != 0
  case 22: return set.fds_bits.22 & mask != 0
  case 23: return set.fds_bits.23 & mask != 0
  case 24: return set.fds_bits.24 & mask != 0
  case 25: return set.fds_bits.25 & mask != 0
  case 26: return set.fds_bits.26 & mask != 0
  case 27: return set.fds_bits.27 & mask != 0
  case 28: return set.fds_bits.28 & mask != 0
  case 29: return set.fds_bits.29 & mask != 0
  case 30: return set.fds_bits.30 & mask != 0
  case 31: return set.fds_bits.31 & mask != 0
  default: return false
  }
}
