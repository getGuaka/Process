#if os(Linux)
  @_exported import Glibc
#else
  @_exported import Darwin.C
#endif


typealias FileDescriptor = Int32

func _pipe() throws -> (FileDescriptor, FileDescriptor) {
  var fds: [Int32] = [0, 0]
  let rv = pipe(&fds)
  if rv == 0 {
    return (fds[0], fds[1])
  } else {
        throw SystemError.pipe(rv)
  }
  
}

func pipe() throws -> (IO, IO) {
  let (fd1, fd2) = try _pipe()
  return (IO(fd: fd1), IO(fd: fd2))
}

enum FileAction {
  case Close(FileDescriptor)
  case Open(FileDescriptor, String, Int32, mode_t)
  case Dup2(FileDescriptor, FileDescriptor)
}

struct Process {
  let pid: pid_t
}

func spawn(_ arguments: [String], environment: [String: String] = [:], fileActions fileActionsArray: [FileAction] = []) throws -> Process {
  let argv = arguments.map { $0.withCString(strdup) }
  defer { for arg in argv { free(arg) } }
  
  var environment = environment
  let env = environment.map { "\($0.0)=\($0.1)".withCString(strdup) }
  defer { env.forEach { free($0) } }
  
  var fileActions = UnsafeMutablePointer<posix_spawn_file_actions_t?>.allocate(capacity: fileActionsArray.count)
  posix_spawn_file_actions_init(fileActions)
  defer { posix_spawn_file_actions_destroy(fileActions) }
  
  for fileAction in fileActionsArray {
    switch fileAction {
    case .Close(let fd):
      posix_spawn_file_actions_addclose(fileActions, fd)
    case .Open(let fd, let path, let oflag, let mode):
      posix_spawn_file_actions_addopen(fileActions, fd, path, oflag, mode)
    case .Dup2(let fd, let newfd):
      posix_spawn_file_actions_adddup2(fileActions, fd, newfd)
    }
  }
  
  var pid = pid_t()
  let rv = posix_spawnp(&pid, argv[0], fileActions, nil, argv + [nil], env + [nil])
  
  guard rv == 0 else {
        throw SystemError.posix_spawn(rv)
  }
  
  return Process(pid: pid)
}


extension Process {
  struct Status {
    private let status: Int32
    
    init(status: Int32) {
      self.status = status
    }
    // WEXITSTATUS
    var exitstatus: Int {
      return Int((status >> 8) & 0xff)
    }
  }
}

func waitpid(pid: pid_t) throws -> Process.Status {
  return try retryInterrupt {
    var status: Int32 = 0
    let rv = waitpid(pid, &status, 0)
    if rv != -1 {
      return Process.Status(status: status)
    } else {
      throw SystemError.waitpid(errno)
    }
  }
}


extension Process {
  func wait() throws -> Status {
    return try waitpid(pid: pid)
  }
}
