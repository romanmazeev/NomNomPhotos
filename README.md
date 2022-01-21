# nomnomPhotos
An application that allows you to view pictures from a remote resource

## Screenshot
![Screenshot](https://raw.githubusercontent.com/romanmazeev/NomNomPhotos/develop/Docs/screenshot.gif?token=GHSAT0AAAAAABHPI3T4BYMHZJX2WXNN4NEEYPUPVBA)

## TODO:
1. Tests
2. Github Actions

## Note
The API of the resource that was given `picsum.photos` is not quite optimally designed for this task.
It contains a downloadable image (large full size) and a link to view on unsplash.
For fast and smooth work we need thumbnails and full size pictures for the details screen. For example `jsonplaceholder.typicode.com/photos`

### Both options are available in the application for clarity
To change endpoint edit `NomNomPhotosApp` use another `environment`
```swift
@main
struct NomNomPhotosApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: .liveWithThumbnails
                )
            )
        }
    }
}
```

## How to run
1. Install [tuist](https://tuist.io). `curl -Ls https://install.tuist.io | bash`
2. Generate xcodeproj and open `tuist generate --open`.

## Dependencies
* [The Composable Arcitecture](https://github.com/pointfreeco/swift-composable-architecture)
* [swift-log](https://github.com/apple/swift-log)
* [CachedAsyncImage](https://github.com/lorenzofiamingo/SwiftUI-CachedAsyncImage)
