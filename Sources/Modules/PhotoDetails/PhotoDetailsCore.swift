//
//  PhotoDetailsCore.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import ComposableArchitecture

struct PhotoDetailsState: Identifiable, Equatable {
    let id: String
    let title: String
    let url: URL
}

enum PhotoDetailsAction {
    case dismiss
}

struct PhotoDetailsEnvironment {}

// MARK: - Reducer
let photoDetailsReducer: Reducer<PhotoDetailsState, PhotoDetailsAction, PhotoDetailsEnvironment> = .combine(
    .init { _, _, _ in return .none }
)
