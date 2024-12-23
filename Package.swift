// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AdventOfCode",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: ["AdventOfCode"]),
        .target(
            name: "Puzzles2018",
            dependencies: ["AdventOfCode"]),
        .target(
            name: "Puzzles2020",
            dependencies: ["AdventOfCode"]),
        .target(
            name: "Puzzles2023",
            dependencies: ["AdventOfCode"]),
    ]
)
