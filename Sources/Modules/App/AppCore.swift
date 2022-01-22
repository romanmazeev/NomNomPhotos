//
//  AppCore.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import ComposableArchitecture
import Logging

struct AppState: Equatable {
    var photosGrid = PhotosGridState()
    var selectedPhoto: PhotoDetailsState?
}

enum AppAction {
    case photosGrid(PhotosGridAction)
    case photoDetails(PhotoDetailsAction)
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
            environment: {
                .init(mainQueue: $0.mainQueue, photosClient: $0.photosClient, logger: $0.logger)
            }
        ),
    photoDetailsReducer
        .optional()
        .pullback(
            state: \.selectedPhoto,
            action: /AppAction.photoDetails,
            environment: { _ in .init() }
        ),
    .init { state, action, _ in
        switch action {
        case .photosGrid(let photosGridAction):
            switch photosGridAction {
            case .onPhotoTap(let id):
                state.selectedPhoto = state.photosGrid.photos[id: id]
                return .none
            default:
                return .none
            }
        case .photoDetails(let photoDetailsAction):
            switch photoDetailsAction {
            case .dismiss:
                state.selectedPhoto = nil
                return .none
            }
        }
    }
)
.debug()
.signpost()
