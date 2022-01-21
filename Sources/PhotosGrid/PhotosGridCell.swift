//
//  PhotosGridCell.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import SwiftUI
import ComposableArchitecture
import CachedAsyncImage

struct PhotosGridCell: View {
    var state: PhotoDetailsState
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            CachedAsyncImage(
                url: state.thumbnailURL,
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
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .matchedGeometryEffect(id: state.id, in: animation)
            
            VStack {
                Spacer()
                HStack {
                    Text(state.title)
                        .bold()
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 2.0)
                        .padding()
                        .matchedGeometryEffect(id: String(state.id) + "text", in: animation)
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct PhotosGridCell_Previews: PreviewProvider {
    struct PhotosGridCell_PreviewsView: View {
        @Namespace var namespace
        var body: some View {
            PhotosGridCell(
                state: .init(
                    id: "1",
                    title: "Test",
                    url: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!,
                    thumbnailURL: URL(string: "https://unsplash.com/photos/yC-Yzbqy7PY")!
                ),
                animation: namespace
            )
        }
    }
    
    static var previews: some View {
        PhotosGridCell_PreviewsView()
    }
}
