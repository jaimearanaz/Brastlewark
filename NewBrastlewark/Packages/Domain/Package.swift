// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
            .iOS(.v18)
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"])
    ],
    dependencies: [
        .package(path: "../Utils"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: ["Utils", "Swinject"]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            resources: [
                .copy("Resources/characters.json"),
                .copy("Resources/one_character.json")
            ]
        )
    ]
)
