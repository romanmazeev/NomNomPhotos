//
//  PhotoDetailsView.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import SwiftUI
import ComposableArchitecture
import CachedAsyncImage

struct PhotoDetailsView: View {
    var store: Store<PhotoDetailsState, PhotoDetailsAction>
    var animation: Namespace.ID
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                VStack {
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
                        case .failure(let error):
                            VStack {
                                Image(systemName: "photo")
                                Text(error.localizedDescription)
                            }
                        @unknown default:
                            Image(systemName: "photo")
                        }
                    }
                    .matchedGeometryEffect(id: viewStore.id, in: animation)
                    
                    VStack {
                        HStack {
                            Text(viewStore.title)
                                .bold()
                                .font(.system(.largeTitle, design: .rounded))
                                .padding(.horizontal)
                                .matchedGeometryEffect(id: String(viewStore.id) + "text", in: animation)
                            Spacer()
                        }
                    }
                }
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            viewStore.send(
                                .dismiss,
                                animation: .spring(response: 0.6, dampingFraction: 0.9)
                            )
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                        }
                        .foregroundColor(.secondary)
                        .frame(width: 40, height: 40)
                    }
                    Spacer()
                }
                .padding()
            }
            .background(.background)
        }
    }
}

struct PhotoDetailsView_Previews: PreviewProvider {
    struct PhotoDetailsView_PreviewsView: View {
        @Namespace var namespace
        var body: some View {
            PhotoDetailsView(
                store: .init(
                    initialState: .init(
                        id: "1",
                        title: "Test",
                        url: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!,
                        thumbnailURL: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!
                    ),
                    reducer: photoDetailsReducer,
                    environment: .init()
                ),
                animation: namespace
            )
        }
    }
    
    static var previews: some View {
        PhotoDetailsView_PreviewsView()
    }
}
