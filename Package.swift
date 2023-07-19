// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
        .package(path: "PredicateBuilderCore"),
        .package(path: "PredicateBuilderTestData")
    ].withMacroDependencyIfPossible(),
    targets: [
        .target(
            name: "PredicateBuilder",
            dependencies: [
                .product(name: "PredicateBuilderCore", package: "PredicateBuilderCore")
            ].withMacroDependencyIfPossible(),
            path: "PredicateBuilder/Sources"
        ),
        .executableTarget(
            name: "PredicateBuilderExample",
            dependencies: [
                .target(name: "PredicateBuilder"),
                .product(name: "PredicateBuilderTestData", package: "PredicateBuilderTestData")
            ].withMacroDependencyIfPossible(),
            path: "PredicateBuilderExample"
        ),
        .testTarget(
            name: "PredicateBuilderTests",
            dependencies: [
                .target(name: "PredicateBuilder"),
                .product(name: "PredicateBuilderTestData", package: "PredicateBuilderTestData")
            ].withMacroDependencyIfPossible(),
            path: "PredicateBuilder/Tests"
        ),
    ]
)

extension Array where Element == Target.Dependency {
    func withMacroDependencyIfPossible() -> Self {
#if(swift(<5.9))
        return self
#else
        var array = self
        array.append(
            .product(name: "PredicateBuilderMacro", package: "PredicateBuilderMacro")
        )
        return array
#endif
    }
}

extension Array where Element == Package.Dependency {
    func withMacroDependencyIfPossible() -> Self {
#if(swift(<5.9))
        return self
#else
        var array = self
        array.append(
            .package(path: "PredicateBuilderMacro")
        )
        return array
#endif
    }
}
