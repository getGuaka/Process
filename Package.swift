import PackageDescription

let package = Package(
    name: "Runner",
    targets: [
      Target(name: "Environ"),
      Target(name: "Runner", dependencies: ["Environ"]),
  ]
)
