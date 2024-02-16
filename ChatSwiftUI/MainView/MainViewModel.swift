//
//  MainViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import OpenAI

@Observable
class MainViewModel {
    
    private let db = DBService()
    private let ai = AIService()
    
    var isSearchEnabled = false
    var isLoading = false
    
    var sendEnable: Bool {
        return editText.isEmpty
    }
    
    var chRecords = [CHRecord]()
    
    var editText = ""
    
    func loadHistory() {
        isLoading = true
        print("Some text \(editText)")
//        isSearchEnabled = !isSearchEnabled
        chRecords = db.getAllRecords()
        isLoading = false
    }
    
    func insertRecord() {
        let rec = CHRecord(id: 10, sender: 1, body: editText)
        chRecords.append(rec)
        db.insert(rec)
    }
    
    func editRecord() {
        var rec = chRecords[chRecords.count - 1]
        rec.body = "Other body"
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
    
    func sendRequest() {
        let chat = Chat(role: Chat.Role.assistant, content: "Send test reply")
        let query = ChatQuery(model: Model.gpt3_5Turbo, messages: [chat])
        ai.sendQuery(query: query)
    }

}
