// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestMyLibrary",
    products: [
        .library(
            name: "TestMyLibrary",
            targets: ["FrameWork1"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TestMyLibrary",
            dependencies: [],
            swiftSettings: [.ena]
        ),
        .binaryTarget(name: "FrameWork1", path: "Sources/FrameWork1/Skia.xcframework"),
//        .binaryTarget(name: "FrameWork", path: "Sources/FrameWork/libskia.xcframework"),
//        .testTarget(
//            name: "TestMyLibraryTests",
//            dependencies: ["TestMyLibrary"]),
    ]
)
