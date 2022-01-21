import ProjectDescription

let infoPlist: [String: InfoPlist.Value] = [ // <1>
    "UILaunchScreen": [:]
]

let project = Project(
    name: "NomNomPhotos",
    packages: [
        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git", requirement: .upToNextMajor(from: "0.33.1")),
        .remote(url: "https://github.com/lorenzofiamingo/SwiftUI-CachedAsyncImage.git", requirement: .upToNextMajor(from: "1.9.0")),
        .remote(url: "https://github.com/apple/swift-log.git", requirement: .upToNextMajor(from: "1.4.2"))
    ],
    targets: [
        Target(
            name: "NomNomPhotos",
            platform: .iOS,
            product: .app,
            bundleId: "com.romanmazeev.NomNomPhotos",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: [
                "Sources/**"
            ],
            resources: [
                "Resources/**"
            ],
            dependencies: [
                .package(product: "ComposableArchitecture"),
                .package(product: "CachedAsyncImage"),
                .package(product: "Logging")
            ]
        )
    ]
)
