import PackageDescription

let package = Package(
    name: "Run",
    targets: [
      Target(name: "Environ"),
      Target(name: "Run", dependencies: ["Environ"]),
      Target(name: "App", dependencies: ["Run"]),
  ]
)
