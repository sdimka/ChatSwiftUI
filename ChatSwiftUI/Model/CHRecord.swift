//
//  CHRecord.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import FMDB

struct CHRecord: Hashable, Decodable, Identifiable {
    
    var id: Int
    var chatId: Int
    let sender: Int
    var body: String
    var usage: ChatUsage?
    
    
    init(id: Int, chatId: Int, sender: Int, body: String, usage: ChatUsage? = nil) {
        self.id = id
        self.chatId = chatId
        self.sender = sender
        self.body = body
        self.usage = usage
    }
    
    init?(from result: FMResultSet) {
        if let body = result.string(forColumn: "body") {
            self.id = Int(result.int(forColumn: "id"))
            self.chatId = Int(result.int(forColumn: "chat_id"))
            self.sender = Int(result.int(forColumn: "sender"))
            self.body = body
            let cu = ChatUsage(
                completionTokens: Int(result.int(forColumn: "completion_tokens")),
                promptTokens: Int(result.int(forColumn: "prompt_tokens")),
                totalTokens: Int(result.int(forColumn: "total_tokens"))
            )
            self.usage = cu
        } else {
            return nil
        }
    }
    
    private enum CodingKeys : String, CodingKey {
        case body = "name_with_middle"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = Int.random(in: 1..<100)
        sender = 1 // Int.random(in: 1..<100)
        body = try container.decode(String.self, forKey: .body)
        chatId = 1
    }
}
