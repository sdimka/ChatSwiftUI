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
    private let qh = QueryHolder()
    private var dbPath: String
    
    init(fileName: String = "test") {
        print("DB Service init")
        // 1 - Get filePath of the SQLite file
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(fileName).sqlite")
        dbPath = fileURL.absoluteString
        //print("DB path: \(fileURL)")
        // Create FMDatabase from filePath
        let db = FMDatabase(url: fileURL)
        
        // Open connection to database
        guard db.open() else {
            fatalError("Unable to open database")
        }
        
        // Initial table creation
        do {
            try db.executeUpdate(qh.createTableChats, values: nil)
            try db.executeUpdate(qh.createTableChRecords, values: nil)
            try db.executeUpdate(qh.createIndexChRecords, values: nil)
            
            try db.executeUpdate(qh.createTableParams, values: nil)
        } catch {
            fatalError("cannot execute query")
        }
        
        self.db = db
    }
    
    func getDBPath() -> String {
        return dbPath
    }
    
    func getChats(completion: @escaping (Result<[Chat], Error>) -> Void) {
        var chats = [Chat]()
        let q = """
            SELECT *
            FROM chats
        """
        do {
            let result = try db.executeQuery(q, values: nil)
            while result.next() {
                if let record = Chat(from: result) {
                    chats.append(record)
                }
            }
            completion(.success(chats))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getChatsAsync() async throws -> [Chat] {
        try await withCheckedThrowingContinuation({ continuation in
            getChats{ res in
                switch res {
                case .success(let chats):
                    continuation.resume(returning: chats)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        })
    }
    
    func getAllRecords(chatId: Int, completion: @escaping (Result<[CHRecord], Error>) -> Void) {
        var records = [CHRecord]()
        let q = """
            SELECT id, sender, body
            FROM ch_records_new
            WHERE chat_id = ?
        """
        do {
            let result = try db.executeQuery(q, values: [chatId])
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
    
    func getAllRecordsAsync(chatId: Int) async throws -> [CHRecord] {
        return try await withCheckedThrowingContinuation({ continuation in
            getAllRecords(chatId: chatId){ res in
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
                INSERT INTO ch_records (sender, body)
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
    
    func getParams(completion: @escaping (Result<[Param], Error>) -> Void) {
        var records = [Param]()
        do {
            let result = try db.executeQuery("SELECT id, type_int, value FROM params", values: nil)
            while result.next() {
                if let record = Param(from: result) {
                    records.append(record)
                }
            }
            completion(.success(records))
        } catch {
            completion(.failure(error))
        }
    }
    
    func setParams(param: Param, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            try db.executeUpdate(
                """
                INSERT INTO params (id, type_int, value)
                VALUES (?, ?, ?)
                ON CONFLICT(type_int)
                DO UPDATE SET value = ?;
                """,
                values: [param.id, param.typeInt, param.value, param.value]
            )
            completion(.success("OK"))
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func getAiToken() async throws ->  String {
        return try await withCheckedThrowingContinuation { continuation in
            getParams { result in
                switch result {
                case .success(let params):
                    if let key = params.first(where: { $0.type == .aiKey }) {
                        continuation.resume(returning: key.value)
                    } else {
                        continuation.resume(throwing: DBErrors.notFound)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}

enum DBErrors: Error {
    case notFound
}
