import PackageDescription

let package = Package(
    name: "Runner",
    targets: [
      Target(name: "RunnerEnviron"),
      Target(name: "Runner", dependencies: ["RunnerEnviron"]),
  ]
)
