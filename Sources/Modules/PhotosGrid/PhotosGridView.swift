//
//  PhotosGridView.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import ComposableArchitecture
import SwiftUI

struct PhotosGridView: View {
    var store: Store<PhotosGridState, PhotosGridAction>
    var animation: Namespace.ID
    
    var body: some View {
        WithViewStore(store) { viewStore in
            switch viewStore.loadingState {
            case .loading:
                ProgressView("Loading...")
            case .failed:
                Text("Error occured")
                Button("Refresh") {
                    viewStore.send(.refresh, animation: .default)
                }
                .buttonStyle(.borderedProminent)
            case .loaded:
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEachStore(
                            store.scope(state: \.filteredPhotos, action: PhotosGridAction.photosGridCell(id:action:))
                        ) { cellStore in
                            PhotosGridCellView(store: cellStore, animation: animation)
                        }
                    }
                    .searchable(
                        text: viewStore.binding(
                            get: \.searchText,
                            send: PhotosGridAction.onSeachTextChange
                        )
                    )
                }
            case .notStarted:
                Color.background
                    .onAppear {
                        viewStore.send(.onAppear, animation: .default)
                    }
            }
        }
    }
}

struct PhotosGridView_Previews: PreviewProvider {
    struct PhotosGridView_PreviewsView: View {
        @Namespace var namespace
        var body: some View {
            PhotosGridView(
                store: .init(
                    initialState: .init(
                        loadingState: .loaded,
                        photos: [
                            .init(
                                id: "1",
                                title: "Test 1",
                                url: URL(string: "https://picsum.photos/id/0/5616/3744")!
                            ),
                            .init(
                                id: "2",
                                title: "Test 2",
                                url: URL(string: "https://picsum.photos/id/0/5616/3744")!
                            )
                        ],
                        searchText: ""),
                    reducer: photosGridReducer,
                    environment: .init()
                ),
                animation: namespace
            )
        }
    }
    
    static var previews: some View {
        PhotosGridView_PreviewsView()
    }
}
