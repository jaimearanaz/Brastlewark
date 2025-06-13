// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
            .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Data",
            dependencies: ["Domain", "Swinject"],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"],
            resources: [
                .copy("Resources/characters.json"),
                .copy("Resources/one_character.json"),
                .copy("Resources/empty_professions_character.json")
            ]
        ),
    ]
)
