//
//  AIService.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import OpenAI

class AIService {
    let openAI: OpenAI
    
    init() {
        let openAI = OpenAI(apiToken: "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")
        self.openAI = openAI
    }
    
    func sendQuery(query: ChatQuery) {
        print("Sending query")
        openAI.chatsStream(query: query) { partialResult in
            switch partialResult {
            case .success(let result):
                print(result.choices)
            case .failure(let error):
                print("Something goes wrong: \(error)")
            }
        } completion: { error in
            //Handle streaming error here
        }
    }
    
    func fetchQueryContinuation(query: ChatQuery) async throws -> ChatStreamResult {
        let lock = NSLock()
        // Bridge between synchronous and asynchronous code using continuation
        let results: ChatStreamResult = try await withCheckedThrowingContinuation({ continuation in
            
            // Async task execute the `fetchAlbums(completion:)` function
            openAI.chatsStream(query: query) { result in
                lock.lock()
                defer { lock.unlock() }
                
                switch result {
                case .success(let result):
                    // Resume with fetched albums
                    continuation.resume(returning: result)
                    
                case .failure(let error):
                    // Resume with error
                    continuation.resume(throwing: error)
                }
            } completion: { error in
                //Handle streaming error here
            }
        })
        
        return results
    }
    
//    func reqV3(query: ChatQuery) {
//        return openAI.chatsStream(query: query)
//
//    }
}
