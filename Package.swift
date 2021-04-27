// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "AKStepper",
  platforms: [
    .iOS(.v12)
  ],
  products: [
    .library(name: "AKStepper", targets: ["AKStepper"])
  ],
  dependencies: [
    .package(name: "AKButton", url: "https://github.com/akolov/AKButton.git", .upToNextMajor(from: "2.0.0"))
  ],
  targets: [
    .target(
      name: "AKStepper",
      dependencies: [
        .product(name: "AKButton", package: "AKButton")
      ]
    )
  ]
)
