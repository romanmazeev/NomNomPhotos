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
    
    var loadingState: LoadingState = .notStarted
    var photos: IdentifiedArrayOf<PhotosGridCellState> = []
    
    // MARK: Search
    var searchText: String = ""
    var filteredPhotos: IdentifiedArrayOf<PhotosGridCellState> {
        searchText.isEmpty ? photos : photos.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}

enum PhotosGridAction {
    case onAppear
    case onSeachTextChange(String)
    case refresh
    
    case photosGridCell(id: String, action: PhotosGridCellAction)
}

struct PhotosGridEnvironment {}

// MARK: - Reducer

let photosGridReducer = Reducer<PhotosGridState, PhotosGridAction, PhotosGridEnvironment>.combine(
    photosGridCellReducer
        .forEach(
            state: \.photos,
            action: /PhotosGridAction.photosGridCell(id:action:),
            environment: { _ in .init() }
        ),
    .init { state, action, environment in
        switch action {
        case .onSeachTextChange(let searchText):
            state.searchText = searchText
            return .none
        case .photosGridCell(let id, let action):
            return .none
        case .onAppear:
            return .none
        case .refresh:
            return .none
        }
    }
)
