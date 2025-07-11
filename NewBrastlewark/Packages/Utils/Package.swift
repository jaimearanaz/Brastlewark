// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Utils",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Utils",
            targets: ["Utils"]),
    ],
    targets: [
        .target(
            name: "Utils"
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]
        ),
    ]
)
