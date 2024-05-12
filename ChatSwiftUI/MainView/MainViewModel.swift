//
//  MainViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import OpenAI
import SwiftUI
import Resolver


//@MainActor
@Observable 
class MainViewModel {
    
    @ObservationIgnored
    @Injected private var db: DBService
    @ObservationIgnored
    @Injected private var ai: AIService
    
    var isSearchEnabled = false
    var isOn = false
    var isLoading : Bool = false {
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
    
    var errorMessage: String = ""
    var errorEnable: Bool = false
    
    var sendEnable: Bool {
        return editText.isEmpty || isLoading
    }
    
    var chats = [Chat]()
    var selectedChart: Int? = 1 {
        willSet(newVal) {
            loadChatData(chatId: newVal!)
        }
    }
    
    var chRecords = [CHRecord]()
    var vm = ScrollToModel()
    
    var editText = ""
    var answerText = ""
    
    func loadHistory() {
        isLoading = true
        Task {
            do {
                try await chats = db.getChatsAsync()
                guard let firstId = chats.first?.id else {
                    return
                }
                selectedChart = firstId
            } catch {
                emitError(String(describing: error))
                print(error)
            }
        }
        isLoading = false
    }
    
    func loadChatData(chatId: Int) {
        Task {
            do {
                try await chRecords = db.getAllRecordsAsync(chatId: chatId)
            } catch {
                emitError(String(describing: error))
            }
        }
    }
            
    
    func insertRecord(chatId: Int, sender: Int, body: String) {
//        isLoading = true
        let rec = CHRecord(id: 10, chatId: chatId, sender: sender, body: body)
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
    
    func deleteRecord(message: CHRecord) {
        isLoading = true
        Task { @MainActor in
            do {
                let _ = try await db.deleteRecordAsync(message)
                guard let selectedChart = selectedChart else { return }
                try await chRecords = db.getAllRecordsAsync(chatId: selectedChart)
                isLoading = false
                
            } catch {
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
    
    func emitError(_ message: String) {
        errorMessage = message
        errorEnable = true
    }
    
    func sendAIReq() {
        isLoading = true
        guard let currentChatId = selectedChart else { return }
        
        insertRecord(chatId: currentChatId, sender: 1, body: editText)
        
        let reqString = editText
        editText = ""
        answerText = ""
        
//        let chat = ChatCompletionMessageParam(role: .user, content: reqString)
        let chatMessage1 = ChatQuery.ChatCompletionMessageParam(role: .user, content: reqString)!
//        let chatMessage2 = ChatQuery.ChatCompletionMessageParam(role: .system, content: "You are senior developer, all code writen in swift")!
        let query = ChatQuery(messages: [chatMessage1], model: .gpt3_5Turbo)
        
        Task {
            do {
                for try await result in try ai.reqV3(query: query) {
                    switch result {
                    case .processing(let data):
                        answerText.append(data)
                    case.finished(_):
                        insertRecord(chatId: currentChatId, sender: 2, body: answerText)
                        isLoading = false
                    }
                }
            } catch {
                emitError(error.localizedDescription)
                print("Request failed with error: \(error)")
            }
        }
    }

}
