//
//  NomNomPhotosApp.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import SwiftUI
import ComposableArchitecture

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
