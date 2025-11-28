// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PredicateBuilder",
    platforms: [
        .macOS(.v12),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "PredicateBuilder",
            targets: ["PredicateBuilder"]
        ),
        .executable(
            name: "PredicateBuilderExample",
            targets: ["PredicateBuilderExample"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1")
    ],
    targets: [
        .target(
            name: "PredicateBuilderCore",
            path: "PredicateBuilderCore/Sources/PredicateBuilderCore"
        ),
        .target(
            name: "PredicateBuilder",
            dependencies: [
                .target(name: "PredicateBuilderCore"),
                .target(name: "PredicateBuilderMacro")
            ],
            path: "PredicateBuilder/Sources"
        ),
        .macro(
            name: "PredicateBuilderMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .target(name: "PredicateBuilderCore")
            ],
            path: "PredicateBuilderMacro/Sources/PredicateBuilderMacroMacros"
        ),
        .target(
            name: "PredicateBuilderMacro",
            dependencies: [
                .target(name: "PredicateBuilderCore"),
                "PredicateBuilderMacroMacros"
            ],
            path: "PredicateBuilderMacro/Sources/PredicateBuilderMacro"
        ),
        .target(
            name: "PredicateBuilderTestData",
            path: "PredicateBuilderTestData/Sources/PredicateBuilderTestData"
        ),
        .executableTarget(
            name: "PredicateBuilderExample",
            dependencies: [
                .target(name: "PredicateBuilder"),
                .target(name: "PredicateBuilderTestData")
            ],
            path: "PredicateBuilderExample"
        ),
        .executableTarget(
            name: "PredicateBuilderMacroClient",
            dependencies: [
                .target(name: "PredicateBuilderMacro"),
                .target(name: "PredicateBuilderTestData")
            ],
            path: "PredicateBuilderMacro/PredicateBuilderMacroClient"
        ),
        .testTarget(
            name: "PredicateBuilderTests",
            dependencies: [
                .target(name: "PredicateBuilder"),
                .target(name: "PredicateBuilderTestData")
            ],
            path: "PredicateBuilder/Tests"
        ),
        .testTarget(
            name: "PredicateBuilderCoreTests",
            dependencies: [
                .target(name: "PredicateBuilderCore")
            ],
            path: "PredicateBuilderCore/Tests/PredicateBuilderCoreTests"
        ),
        .testTarget(
            name: "PredicateBuilderMacroTests",
            dependencies: [
                "PredicateBuilderMacroMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            path: "PredicateBuilderMacro/Tests/PredicateBuilderMacroTests"
        ),
        .testTarget(
            name: "PredicateBuilderTestDataTests",
            dependencies: [
                .target(name: "PredicateBuilderTestData")
            ],
            path: "PredicateBuilderTestData/Tests/PredicateBuilderTestDataTests"
        ),
    ]
)
