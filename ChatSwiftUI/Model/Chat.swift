//
//  Chat.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 10.05.2024.
//

import Foundation
import FMDB

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
