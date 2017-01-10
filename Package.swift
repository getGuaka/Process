import PackageDescription

let package = Package(
    name: "Process",
    targets: [
      Target(name: "Process"),
  ],
  dependencies: [
    .Package(url: "https://github.com/oarrabi/Environ.git", majorVersion: 0)
  ]
)
