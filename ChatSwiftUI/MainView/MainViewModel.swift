//
//  MainViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation

@Observable
class MainViewModel {
    
    private let db = DBService()
    
    var isSearchEnabled = false
    
    var chRecords = [CHRecord]()
    
    func performSearch() {
        print("Some text")
        isSearchEnabled = !isSearchEnabled
        chRecords = db.getAllRecords()
    }
    
    func insertRecord() {
        let rec = CHRecord(from: 1, body: "Some string")
        chRecords.append(rec)
        db.insert(rec)
    }
    
    func insertRandomRecord() {
        let url = URL(string: "https://random-data-api.com/api/name/random_name")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                fatalError("No data")
            }
            
            DispatchQueue.main.async {
                let rec = try! JSONDecoder().decode(CHRecord.self, from: data)
                self.db.insert(rec)
            }
        }
        task.resume()
    }

}
