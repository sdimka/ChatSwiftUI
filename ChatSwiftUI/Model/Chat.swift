//
//  Chat.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 10.05.2024.
//

import Foundation
import FMDB
import OpenAI

struct Chat: Hashable, Decodable, Identifiable {
    
    var id: Int
    let name: String
    var icon: String
    
    
    init(id: Int, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    init?(from result: FMResultSet) {
        if let name = result.string(forColumn: "name") {
            self.id = Int(result.int(forColumn: "id"))
            self.name = name
            self.icon = String(result.string(forColumn: "icon") ?? "")
        } else {
            return nil
        }
    }
}

struct ChatUsage: Equatable, Hashable {
    public let completionTokens: Int
    public let promptTokens: Int
    public let totalTokens: Int
}

extension ChatUsage {
    init(from: ChatStreamResult.Usage) {
        self.completionTokens = from.completionTokens
        self.promptTokens = from.promptTokens
        self.totalTokens = from.totalTokens
    }
}
