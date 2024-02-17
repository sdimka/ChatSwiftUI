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
    var errorMessage: String = ""
    var errorEnable: Bool = false
    
    var sendEnable: Bool {
        return editText.isEmpty || isLoading
    }
    
    
    
    var chRecords = [CHRecord]()
    
    var editText = ""
    
    @MainActor
    func loadHistory() {
        isLoading = true
        Task {
            do {
                try await chRecords = db.getAllRecordsAsync()
            } catch {
                emitError(String(describing: error))
                print(error)
            }
        }
        isLoading = false
    }
    
    func insertRecord() {
        isLoading = true
        let rec = CHRecord(id: 10, sender: 1, body: editText)
        chRecords.append(rec)
        Task {
            do {
                let _ = try await db.insertAsync(rec)
                isLoading = false
            } catch {
//                print("DB failed with error: \(error)")
                self.emitError(error.localizedDescription)
                isLoading = false
            }
        }
    }
    
    func editRecord() {
        isLoading = true
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            isLoading = false
        }
    }
    
    func insertRandomRecord() {
        let url = URL(string: "https://random-data-api.com/api/name/random_name")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                fatalError("No data")
            }
            
            DispatchQueue.main.async {
                let rec = try! JSONDecoder().decode(CHRecord.self, from: data)
                self.db.insert(rec){ res in
                    print(res)
                }
            }
        }
        task.resume()
    }
    
    func sendRequest() {
        let chat = Chat(role: Chat.Role.assistant, content: "Send test reply")
        let query = ChatQuery(model: Model.gpt3_5Turbo, messages: [chat])
        ai.sendQuery(query: query)
    }
    
    func emitError(_ message: String) {
        errorMessage = message
        errorEnable = true
    }

}
