//
//  QueryHolder.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 10.05.2024.
//

import Foundation


struct QueryHolder {
    var createTableChats: String {
        return """
            CREATE TABLE IF NOT EXISTS chats (
                id     INTEGER primary key autoincrement,
                name   TEXT,
                icon   TEXT
            );
            """
    }
    
    var createTableChRecords: String {
        return """
            CREATE TABLE IF NOT EXISTS ch_records_new (
                id      INTEGER PRIMARY KEY autoincrement,
                chat_id INTEGER,
                sender  INTEGER,
                body    TEXT,
                FOREIGN KEY (chat_id) REFERENCES chats(id)
            );
        """
    }
    
    var createIndexChRecords: String {
        return """
            CREATE INDEX IF NOT EXISTS ch_records_chid
            ON ch_records_new(chat_id);
        """
    }
    
    var createTableParams: String {
        return """
            CREATE TABLE if not exists params(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                type_int integer,
                value TEXT,
            UNIQUE(type_int) ON CONFLICT IGNORE)
        """
    }
}
