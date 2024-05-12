//
//  AIService.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import OpenAI
import Resolver

class AIService {
    private var openAI: OpenAI? = nil
    private var token: String? = nil
    
    @Injected private var db: DBService
    
    func getChat() async throws -> OpenAI {
        let currToken = try await db.getAiToken()
        if token == nil || token != currToken {
            token = currToken
            openAI = OpenAI(apiToken: token!)
        }
        guard let openAI = openAI else {
            throw AIError.openAINotInitialized
        }
        return openAI
    }
    
    func sendQuery(query: ChatQuery) {
        print("Sending query")
        openAI?.chatsStream(query: query) { partialResult in
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
            openAI?.chatsStream(query: query) { result in
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
    
    enum Status {
            case processing(String)
            case finished(Int)
        }
    
    func reqV3(query: ChatQuery) throws -> AsyncThrowingStream<Status, any Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    if openAI == nil { try await getChat() }
                    
                    guard let openAI = openAI else { throw AIError.openAINotInitialized }
                    
                    for try await result in openAI.chatsStream(query: query) {
                        if let choice = result.choices.first {
                            if let content = choice.delta.content {
                                continuation.yield(.processing(content))
                            }
                            if choice.finishReason != nil {
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                continuation.yield(.finished(1))
                            }
                        }
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

enum AIError: Error {
    case openAINotInitialized
}
