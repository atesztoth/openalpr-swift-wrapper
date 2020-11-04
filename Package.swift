// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenALPR",
    targets: [
        .systemLibrary(name: "OpenAlprSysLib", path: "Sources/openalpr", pkgConfig: "openalpr"),
        .target(
            name: "OpenALPRWrapper",
            dependencies: ["OpenAlprSysLib"])
    ]
)
