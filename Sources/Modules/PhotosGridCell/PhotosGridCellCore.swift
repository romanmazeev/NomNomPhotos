//
//  PhotosGridCellCore.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 23/01/22.
//

import ComposableArchitecture
import Logging

struct PhotosGridCellState: Identifiable, Equatable {
    let id: String
    let title: String
    let url: URL
}

extension PhotosGridCellState {
    init(photo: Photo) {
        id = photo.id
        title = photo.title
        url = photo.thumbnailURL
    }
}

enum PhotosGridCellAction {
    case onTap
}

struct PhotosGridCellEnvironment {}

// MARK: - Reducer
let photosGridCellReducer: Reducer<PhotosGridCellState, PhotosGridCellAction, PhotosGridCellEnvironment> = .combine(
    .init { _, _, _ in return .none }
)
