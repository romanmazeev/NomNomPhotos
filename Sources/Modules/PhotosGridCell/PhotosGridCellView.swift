//
//  PhotosGridCellView.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import SwiftUI
import ComposableArchitecture
import CachedAsyncImage

struct PhotosGridCellView: View {
    var store: Store<PhotosGridCellState, PhotosGridCellAction>
    var animation: Namespace.ID
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                CachedAsyncImage(
                    url: viewStore.url,
                    transaction: Transaction(animation: .default)
                ) { phase in
                    switch phase {
                    case .empty:
                        Color.secondary.opacity(0.1)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        VStack {
                            Image(systemName: "photo")
                            Text("Error occured")
                        }
                    @unknown default:
                        Image(systemName: "photo")
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .matchedGeometryEffect(id: viewStore.id, in: animation)
                
                VStack {
                    Spacer()
                    HStack {
                        Text(viewStore.title)
                            .bold()
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 2.0)
                            .padding()
                            .matchedGeometryEffect(id: String(viewStore.id) + "text", in: animation)
                        Spacer()
                    }
                }
            }
            .padding()
            .onTapGesture {
                viewStore.send(.onTap, animation: .spring(response: 0.5, dampingFraction: 0.6))
            }
        }
    }
}

struct PhotosGridCellView_Previews: PreviewProvider {
    struct PhotosGridCellView_PreviewsView: View {
        @Namespace var namespace
        var body: some View {
            PhotosGridCellView(
                store: .init(
                    initialState: .init(
                        id: "1",
                        title: "Test",
                        url: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!
                    ),
                    reducer: photosGridCellReducer,
                    environment: .init()
                ),
                animation: namespace
            )
        }
    }
    
    static var previews: some View {
        PhotosGridCellView_PreviewsView()
    }
}
