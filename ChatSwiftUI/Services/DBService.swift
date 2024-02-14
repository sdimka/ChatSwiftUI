//
//  DBService.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import FMDB


class DBService {
    
    private let db: FMDatabase
    
    init(fileName: String = "test") {
        // 1 - Get filePath of the SQLite file
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(fileName).sqlite")
        
        // 2 - Create FMDatabase from filePath
        let db = FMDatabase(url: fileURL)
        
        // 3 - Open connection to database
        guard db.open() else {
            fatalError("Unable to open database")
        }
        
        // 4 - Initial table creation
        do {
            try db.executeUpdate("create table if not exists users(username varchar(255) primary key, age integer)", values: nil)
        } catch {
            fatalError("cannot execute query")
        }
        
        self.db = db
    }
}
