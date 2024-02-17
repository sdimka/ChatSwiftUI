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
        print("DB path: \(fileURL)")
        // 2 - Create FMDatabase from filePath
        let db = FMDatabase(url: fileURL)
        
        // 3 - Open connection to database
        guard db.open() else {
            fatalError("Unable to open database")
        }
        
        // 4 - Initial table creation
        do {
            try db.executeUpdate("create table if not exists ch_records(id INTEGER PRIMARY KEY AUTOINCREMENT, sender integer, body TEXT)", values: nil)
        } catch {
            fatalError("cannot execute query")
        }
        
        self.db = db
    }
    
    func getAllRecords(completion: @escaping (Result<[CHRecord], Error>) -> Void) {
        var records = [CHRecord]()
        do {
            let result = try db.executeQuery("select id, sender, body from ch_records", values: nil)
            while result.next() {
                if let record = CHRecord(from: result) {
                    records.append(record)
                } 
            }
            completion(.success(records))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getAllRecordsAsync() async throws -> [CHRecord] {
        try await withCheckedThrowingContinuation({ continuation in
            getAllRecords{ res in
                switch res {
                case .success(let records):
                    continuation.resume(returning: records)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        })
    }

    
    func insert(_ record: CHRecord, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            try db.executeUpdate(
                """
                insert into ch_records (sender, body)
                values (?, ?)
                """,
                values: [record.sender, record.body]
            )
            completion(.success("OK"))
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func insertAsync(_ record: CHRecord) async throws -> String {
        
        let result: String = try await withCheckedThrowingContinuation({ continuation in
            insert(record){ res in
                switch res {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
        
        return result
    }
    
    
}
