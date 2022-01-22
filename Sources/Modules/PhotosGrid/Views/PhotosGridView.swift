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
            case .loaded:
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEachStore(
                            self.store.scope(state: \.filteredPhotos, action: PhotosGridAction.photoDetailsCell(id:action:))
                        ) { cellStore in
                            WithViewStore(cellStore) { cellViewStore in
                                PhotosGridCell(state: cellViewStore.state, animation: animation)
                                    .onTapGesture {
                                        viewStore.send(
                                            .onPhotoTap(id: cellViewStore.id),
                                            animation: .spring(response: 0.5, dampingFraction: 0.6)
                                        )
                                    }
                            }
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
                    initialState: .init(),
                    reducer: photosGridReducer,
                    environment: .init(mainQueue: .main, photosClient: .mock, logger: .init(label: ""))
                ),
                animation: namespace
            )
        }
    }
    
    static var previews: some View {
        PhotosGridView_PreviewsView()
    }
}
