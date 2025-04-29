// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "Win32NativeExecutors",
  products: [
    .library(
      name: "Win32NativeExecutors",
      targets: ["Win32NativeExecutors"]),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-testing.git", from: "0.2.0"),
  ],
  targets: [
    .target(
      name: "Win32NativeExecutors"),
    .testTarget(
      name: "Win32NativeExecutorsTests",
      dependencies: [
        "Win32NativeExecutors",
        .product(name: "Testing", package: "swift-testing"),
      ]
    ),
  ]
)
