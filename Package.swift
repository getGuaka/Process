import PackageDescription

let package = Package(
    name: "Process",
    targets: [
      Target(name: "ProcessEnviron"),
      Target(name: "Process", dependencies: ["ProcessEnviron"]),
  ]
)
