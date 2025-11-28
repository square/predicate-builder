// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConsumptionTest",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
    ],
    dependencies: [
        .package(path: "..")
    ],
    targets: [
        .executableTarget(
            name: "ValidCode",
            dependencies: [
                .product(name: "PredicateBuilder", package: "predicate-builder"),
            ],
            path: "Sources/ValidCode"
        ),
        .executableTarget(
            name: "InvalidCode",
            dependencies: [
                .product(name: "PredicateBuilder", package: "predicate-builder"),
            ],
            path: "Sources/InvalidCode"
        ),
    ]
)
