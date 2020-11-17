// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AKStepper",
  platforms: [
    .iOS(.v12)
  ],
  products: [
    .library(name: "AKStepper", targets: ["AKStepper"])],
  dependencies: [
    .package(url: "https://github.com/akolov/AKButton.git", from: "1.0.4")
  ],
  targets: [
    .target(name: "AKStepper", dependencies: ["AKButton"])
  ]
)
