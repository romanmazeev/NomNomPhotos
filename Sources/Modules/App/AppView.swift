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
                .onAppear { viewStore.send(.onAppear, animation: .default) }
                .navigationViewStyle(.stack)
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

struct AppView_Previews: PreviewProvider {
    struct AppView_PreviewsView: View {
        @Namespace var namespace
        var body: some View {
            AppView(
                store: .init(
                    initialState: .init(),
                    reducer: appReducer,
                    environment: .init(
                        photosClient: .mock,
                        logger: .init(label: ""),
                        mainQueue: .main
                    )
                )
            )
        }
    }
    
    static var previews: some View {
        AppView_PreviewsView()
    }
}
