//
//  AppView.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    @Namespace var animation
    
    var body: some View {
        ZStack {
            WithViewStore(store) { viewStore in
                NavigationView {
                    PhotosGridView(
                        store: self.store.scope(
                            state: \.photosGrid,
                            action: AppAction.photosGrid
                        ),
                        animation: animation
                    )
                    .navigationTitle("Photos")
                }
                .zIndex(1)
            }
            
            IfLetStore(
                self.store.scope(state: \.selectedPhoto, action: AppAction.photoDetails)
            ) { selectedStore in
                PhotoDetailsView(store: selectedStore, animation: animation)
                    .zIndex(2)
            }
        }
    }
}
