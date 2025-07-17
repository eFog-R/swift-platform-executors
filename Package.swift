// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "SwiftPlatformExecutors",
  products: [
    .library(
      name: "Win32NativeExecutors",
      targets: ["Win32NativeExecutors"]
    ),
    .library(
      name: "PThreadExecutors",
      targets: ["PThreadExecutors"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "Win32NativeExecutors"
    ),
    .target(
      name: "PThreadExecutors",
      dependencies: [
        .product(name: "DequeModule", package: "swift-collections"),
        .target(name: "CPThreadExecutors"),
      ]
    ),
    .target(
      name: "CPThreadExecutors",
      cSettings: [
        .define("_GNU_SOURCE")
      ]
    ),
    .testTarget(
      name: "Win32NativeExecutorsTests",
      dependencies: [
        "Win32NativeExecutors"
      ]
    ),
    .testTarget(
      name: "PThreadExecutorsTests",
      dependencies: [
        "PThreadExecutors"
      ]
    ),
  ]
)
