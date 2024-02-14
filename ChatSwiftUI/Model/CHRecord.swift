//
//  CHRecord.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import FMDB

struct CHRecord: Hashable, Decodable {
    let sender: Int
    let body: String
    
    
    init(from: Int, body: String) {
        self.sender = from
        self.body = body
    }
    
    init?(from result: FMResultSet) {
        if let body = result.string(forColumn: "body") {
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
        sender = 1 // Int.random(in: 1..<100)
        body = try container.decode(String.self, forKey: .body)
        
    }
}
