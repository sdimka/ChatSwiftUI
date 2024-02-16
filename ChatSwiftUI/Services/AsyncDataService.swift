//
//  AsyncDataService.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation


struct AsyncDataService {
    
    enum AlbumsFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func fetchAlbums(completion: @escaping (Result<[Artist], Error>) -> Void) {
        
        // Create URL
        guard let url = URL(string: "http://192.168.3.20:5000/Artists/GetArtists/") else {
            completion(.failure(AlbumsFetcherError.invalidURL))
            return
        }
        
        // Create URL session data task
        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(AlbumsFetcherError.missingData))
                return
            }
            
            do {
                // Parse the JSON data
                let result = try JSONDecoder().decode([Artist].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    static func fetchArtistWithContinuation() async throws -> [Artist] {
        
        // Bridge between synchronous and asynchronous code using continuation
        let artists: [Artist] = try await withCheckedThrowingContinuation({ continuation in
            
            // Async task execute the `fetchAlbums(completion:)` function
            fetchAlbums { result in
                
                switch result {
                case .success(let artists):
                    // Resume with fetched albums
                    continuation.resume(returning: artists)
                    
                case .failure(let error):
                    // Resume with error
                    continuation.resume(throwing: error)
                }
            }
        })
        
        return artists
    }
    
    static func fetchArtistsWithAsyncURLSession() async throws -> [Artist] {

        guard let url = URL(string: "http://192.168.3.20:5000/Artists/GetArtists/") else {
            throw AlbumsFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let artists = try JSONDecoder().decode([Artist].self, from: data)
        return artists
    }
}

struct Artist: Codable, Hashable {
    let id: Int
    let score: Int
    let title: String
    let qType: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id_q"
        case score = "score"
        case title = "title"
        case qType = "q_type"
    }
}
