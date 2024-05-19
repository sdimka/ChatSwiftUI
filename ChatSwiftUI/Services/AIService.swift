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
        //
        
        Task {
            do {
                let result: ChatResult = try await openAI!.chats(query: query)
                result.usage
            }
        }
        //
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
        case usageData(ChatStreamResult.Usage)
        case finished(Int)
    }
    
    func reqV3(query: ChatQuery) throws -> AsyncThrowingStream<Status, any Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    if openAI == nil { try await _ = getChat() }
                    
                    guard let openAI = openAI else { throw AIError.openAINotInitialized }
                    
                    for try await result in openAI.chatsStream(query: query) {
                        if let choice = result.choices.first {
                            
                            if let content = choice.delta.content {
                                continuation.yield(.processing(content))
                            }
                        }
                        if let usage = result.usage {
                            continuation.yield(.usageData(usage))
                            print("Usage pt: \(usage.promptTokens)")
                        }
                    }
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    continuation.yield(.finished(1))
                    
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


//public extension Model {
//    /// `gpt-4o`, currently the most advanced, multimodal flagship model that's cheaper and faster than GPT-4 Turbo.
//    static let gpt4_o = "gpt-4o"
//
//    /// `gpt-4-turbo`, The latest GPT-4 Turbo model with vision capabilities. Vision requests can now use JSON mode and function calling and more. Context window: 128,000 tokens
//    static let gpt4_turbo = "gpt-4-turbo"
//}

//struct StreamOptions: Codable {
//    public let includeUsage: Bool
//    
//    public enum CodingKeys: String, CodingKey {
//        case includeUsage = "include_usage"
//    }
//}
//
//protocol WithStreamingOptions {
//    var streamOptions: StreamOptions? { get }
//}
//
//extension ChatQuery {
//    var streamOptions: StreamOptions {
//        return StreamOptions(includeUsage: true)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        print("In encoder")
//    }
//    
//    public enum CodingKeys: String, CodingKey {
//        case messages
//        case model
//        case frequencyPenalty = "frequency_penalty"
//        case logitBias = "logit_bias"
//        case logprobs
//        case maxTokens = "max_tokens"
//        case n
//        case presencePenalty = "presence_penalty"
//        case responseFormat = "response_format"
//        case seed
//        case stop
//        case temperature
//        case toolChoice = "tool_choice"
//        case tools
//        case topLogprobs = "top_logprobs"
//        case topP = "top_p"
//        case user
//        case stream
//        case streamOptions = "stream_options"
//    }
//}


//extension ChatStreamResult {
//    public struct Usage: Codable, Equatable {
//        let completionTokens: Int
//        let promptTokens: Int
//        let totalTokens: Int
//        
//        public enum CodingKeys: String, CodingKey {
//            case completionTokens = "completion_tokens"
//            case promptTokens = "prompt_tokens"
//            case totalTokens = "total_tokens"
//        }
//    }
//    
//    private struct CustomPropertyHolder {
//        static var _valueHolder = [String: ChatStreamResult.Usage]()
//    }
//    
//    public var usage: Usage? {
//        get {
//            return CustomPropertyHolder._valueHolder[self.id]
//        }
//        set(newValue) {
//            CustomPropertyHolder._valueHolder[self.id] = newValue
//        }
//    }
//    
//    public enum CodingKeys: String, CodingKey {
//        case id
//        case object
//        case created
//        case model
//        case choices
//        case systemFingerprint = "system_fingerprint"
//        case usage = "usage"
//    }
//}
