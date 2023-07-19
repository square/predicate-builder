// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PredicateBuilderMacro",
    platforms: [.macOS(.v12), .iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PredicateBuilderMacro",
            targets: ["PredicateBuilderMacro"]
        ),
        .executable(
            name: "PredicateBuilderMacroClient",
            targets: ["PredicateBuilderMacroClient"]
        ),
    ],
    dependencies: [
        // Depend on the latest Swift 5.9 prerelease of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", revision: "a90e1be0bb5171e6da973946e712ade67526c207"),
        .package(name: "PredicateBuilderCore", path: "../PredicateBuilderCore"),
        .package(name: "PredicateBuilderTestData", path: "../PredicateBuilderTestData")
    ],
    targets: [
        .macro(
            name: "PredicateBuilderMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "PredicateBuilderCore", package: "PredicateBuilderCore")
            ]
        ),
        .target(
            name: "PredicateBuilderMacro",
            dependencies: [
                .product(name: "PredicateBuilderCore", package: "PredicateBuilderCore"),
                "PredicateBuilderMacroMacros"
            ]
        ),
        .executableTarget(
            name: "PredicateBuilderMacroClient",
            dependencies: [
                .target(name: "PredicateBuilderMacro"),
                .product(name: "PredicateBuilderTestData", package: "PredicateBuilderTestData")
            ],
            path: "PredicateBuilderMacroClient/"
        ),
        .testTarget(
            name: "PredicateBuilderMacroTests",
            dependencies: [
                "PredicateBuilderMacroMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
