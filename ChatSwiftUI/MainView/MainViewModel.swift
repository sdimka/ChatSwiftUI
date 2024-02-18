//
//  MainViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import OpenAI
import SwiftUI


@MainActor
class MainViewModel: ObservableObject {
    
    private let db = DBService()
    private let ai = AIService()
    
    @Published var isSearchEnabled = false
    @Published var isOn = false
    @Published var isLoading : Bool = false {
            didSet {
                withAnimation {
                    if isLoading {
                        isOn = true
                    }
                    else {
                        isOn = false
                    }
                }
            }
        }
    
    @Published var errorMessage: String = ""
    @Published var errorEnable: Bool = false
    
    var sendEnable: Bool {
        return editText.isEmpty || isLoading
    }
    
    @Published var chRecords = [CHRecord]()
    @Published var vm = ScrollToModel()
    
    @Published var editText = ""
    @Published var answerText = ""
    
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
    
    func insertRecord(sender: Int, body: String) {
//        isLoading = true
        let rec = CHRecord(id: 10, sender: sender, body: body)
        chRecords.append(rec)
        Task {
            do {
                let _ = try await db.insertAsync(rec)
//                isLoading = false
            } catch {
//                print("DB failed with error: \(error)")
                self.emitError(error.localizedDescription)
//                isLoading = false
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
    
    func emitError(_ message: String) {
        errorMessage = message
        errorEnable = true
    }
    
    func sendAIReq() {
        isLoading = true
        insertRecord(sender: 1, body: editText)
        let reqString = editText
        editText = ""
        answerText = ""
        let chat = Chat(role: Chat.Role.assistant, content: reqString)
        let query = ChatQuery(model: Model.gpt3_5Turbo, messages: [chat])
        Task {
            do {
                for try await result in ai.openAI.chatsStream(query: query) {
                    if result.choices.count > 0 {
                        let choice = result.choices[0]
                        if choice.finishReason == nil {
                            answerText = answerText.appending(choice.delta.content ?? "NoN")
                        } else {
                            try await Task.sleep(nanoseconds: 1_000_000_000)
                            insertRecord(sender: 2, body: answerText)
                            self.isLoading = false
                        }
//                        print("Choice: \(choice)")
                    }
//                    print("Data: \(result)")
                }
                
            } catch {
                emitError(error.localizedDescription)
                print("Request failed with error: \(error)")
            }
        }
    }

}
