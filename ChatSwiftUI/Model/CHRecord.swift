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
    let sender: Int
    var body: String
    
    
    init(id: Int, sender: Int, body: String) {
        self.id = id
        self.sender = sender
        self.body = body
    }
    
    init?(from result: FMResultSet) {
        if let body = result.string(forColumn: "body") {
            self.id = Int(result.int(forColumn: "id"))
            self.sender = Int(result.int(forColumn: "sender"))
            self.body = body
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
    }
}
