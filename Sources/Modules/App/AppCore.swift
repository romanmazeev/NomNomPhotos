//
//  AppCore.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import ComposableArchitecture
import Logging

struct AppState: Equatable {
    var photos: [Photo] = []
    
    var photosGrid = PhotosGridState()
    var selectedPhoto: PhotoDetailsState?
}

enum AppAction {
    case onAppear
    case photosGrid(PhotosGridAction)
    case photoDetails(PhotoDetailsAction)
    
    case photosResponse(Result<[Photo], PhotosClient.Error>)
}

struct AppEnvironment {
    var photosClient: PhotosClient
    var logger: Logger
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let liveWithThumbnails = Self(
        photosClient: .withThumbnails,
        logger: .init(label: "com.NomNomPhotos.withThumbnails"),
        mainQueue: .main
    )
    
    static let liveWithoutThumbnails = Self(
        photosClient: .withoutThumbnails,
        logger: .init(label: "com.NomNomPhotos.withoutThumbnails"),
        mainQueue: .main
    )
    
    static let mock = Self(
        photosClient: .mock,
        logger: .init(label: "com.NomNomPhotos.mock"),
        mainQueue: .main
    )
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    photosGridReducer
        .pullback(
            state: \.photosGrid,
            action: /AppAction.photosGrid,
            environment: { _ in  .init() }
        ),
    photoDetailsReducer
        .optional()
        .pullback(
            state: \.selectedPhoto,
            action: /AppAction.photoDetails,
            environment: { _ in .init() }
        ),
    .init { state, action, environment in
        switch action {
        case .onAppear:
            guard state.photosGrid.loadingState == .notStarted else { return .none }
            return environment.photosClient.fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(AppAction.photosResponse)
        case .photosGrid(let photosGridAction):
            switch photosGridAction {
            case .photosGridCell(let id, let action):
                switch action {
                case .onTap:
                    guard let selectedPhotoState = state.photosGrid.photos[id: id],
                          let selectedPhotoFullImageURL = state.photos.first(where: { $0.id == selectedPhotoState.id })?.url else {
                              return .none
                          }

                    state.selectedPhoto = .init(
                        id: selectedPhotoState.id,
                        title: selectedPhotoState.title,
                        url: selectedPhotoFullImageURL
                    )
                    return .none
                }
            default:
                return .none
            }
        case .photoDetails(let photoDetailsAction):
            switch photoDetailsAction {
            case .dismiss:
                state.selectedPhoto = nil
                return .none
            }
        case .photosResponse(.success(let photos)):
            state.photos = photos
            state.photosGrid.photos = IdentifiedArrayOf(uniqueElements: photos.map {
                .init(id: $0.id, title: $0.title, url: $0.thumbnailURL)
            })
            state.photosGrid.loadingState = .loaded
            return .none
        case .photosResponse(.failure(let error)):
            environment.logger.error("\(error.localizedDescription)")
            state.photos = []
            state.photosGrid.photos = []
            state.photosGrid.loadingState = .failed
            return .none
        }
    }
)
.debug()
.signpost()
