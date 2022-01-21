//
//  PhotosGridCore.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import ComposableArchitecture
import Logging

struct PhotosGridState: Equatable {
    enum LoadingState: Equatable {
        case notStarted
        case loading
        case loaded
        case failed
    }
    
    var isLoading: Bool { loadingState == .loading }
    var loadingState: LoadingState = .notStarted
    var photos: IdentifiedArrayOf<PhotoDetailsState> = []
    
    // MARK: Search
    var searchText: String = ""
    var filteredPhotos: IdentifiedArrayOf<PhotoDetailsState> {
        searchText.isEmpty ? photos : photos.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}

enum PhotosGridAction {
    case onAppear
    case refresh
    case photosResponse(Result<[Photo], PhotosClient.Error>)
    case onSeachTextChange(String)
    
    case photoDetailsCell(id: String, action: PhotoDetailsAction)
    case onPhotoTap(id: String)
}

struct PhotosGridEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let photosClient: PhotosClient
    let logger: Logger
}

// MARK: - Reducer

let photosGridReducer = Reducer<PhotosGridState, PhotosGridAction, PhotosGridEnvironment>.combine(    
        .init { state, action, environment in
            var refreshEffect: Effect<PhotosGridAction, Never> {
                state.loadingState = .loading
                return environment.photosClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(PhotosGridAction.photosResponse)
            }
            
            switch action {
            case .onAppear:
                guard state.loadingState == .notStarted else { return .none }
                return refreshEffect
            case .photosResponse(.success(let photos)):
                state.photos = IdentifiedArrayOf(uniqueElements: photos.map {
                    .init(id: $0.idString, title: $0.title, url: $0.fullSizeUrl, thumbnailURL: $0.thumbnailURL)
                })
                state.loadingState = .loaded
                return .none
            case .photosResponse(.failure(let error)):
                environment.logger.error("\(error.localizedDescription)")
                state.photos = []
                state.loadingState = .failed
                return .none
            case .onSeachTextChange(let searchText):
                state.searchText = searchText
                return .none
            case .refresh:
                return refreshEffect
            case .photoDetailsCell(let id, let action):
                return .none
            case .onPhotoTap(let id):
                return .none
            }
        }
)
