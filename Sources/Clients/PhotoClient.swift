//
//  PhotoClient.swift
//  NomNomPhotos
//
//  Created by Roman Mazeev on 21/01/22.
//

import ComposableArchitecture

// MARK: - API models
protocol Photo {
    var idString: String { get }
    var title: String { get }
    var fullSizeUrl: URL { get }
    var thumbnailURL: URL { get }
}

struct PhotoWithThumbnail: Equatable, Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}

extension PhotoWithThumbnail: Photo {
    var idString: String { String(id) }
    
    var fullSizeUrl: URL { url }
    var thumbnailURL: URL { thumbnailUrl }
}

struct PhotoWithoutThumbnail: Equatable, Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    /// URL from Unsplash website
    let url: URL
    /// Huge image
    let downloadURL: URL
    
}

extension PhotoWithoutThumbnail: Photo {
    var idString: String { id }
    var title: String { author }
    var fullSizeUrl: URL { downloadURL }
    var thumbnailURL: URL { downloadURL }
}

extension PhotoWithoutThumbnail {
    private enum CodingKeys: String, CodingKey {
        case downloadURL = "download_url"
        
        case id, author, width, height, url
    }
}

// MARK: - API Client
struct PhotosClient {
    var fetch: () -> Effect<[Photo], Error>
    
    struct Error: Swift.Error, Equatable {}
}

extension PhotosClient {
    static let withThumbnails = Self(
        fetch: {
            Effect.task {
                do {
                    // TODO: Return error
                    guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return [] }

                    let (data, _) = try await URLSession.shared.data(from: url)
                    return try Array(JSONDecoder().decode([PhotoWithThumbnail].self, from: data).prefix(15))
                } catch {
                    // TODO: Return error
                    print(error.localizedDescription)
                    return []
                }
            }
            .setFailureType(to: Error.self)
            .eraseToEffect()
        }
    )
}

extension PhotosClient {
    static let withoutThumbnails = Self(
        fetch: {
            Effect.task {
                do {
                    // TODO: Return error
                    guard let url = URL(string: "https://picsum.photos/v2/list") else { return [] }

                    let (data, _) = try await URLSession.shared.data(from: url)
                    return try Array(JSONDecoder().decode([PhotoWithoutThumbnail].self, from: data))
                } catch {
                    // TODO: Return error
                    print(error.localizedDescription)
                    return []
                }
            }
            .setFailureType(to: Error.self)
            .eraseToEffect()
        }
    )
}


extension PhotosClient {
    static let mock = Self(
        fetch: {
            Effect.task {
                return []
            }
            .setFailureType(to: Error.self)
            .eraseToEffect()
        }
    )
}
