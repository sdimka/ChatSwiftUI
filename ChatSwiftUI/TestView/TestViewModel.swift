//
//  TestViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import OpenAI
import Resolver


@Observable
class TestViewModel {
    
    var artists = [Artist]()
    var isLoading: Bool = false
    var textData: String = ""
    
    @ObservationIgnored
    @Injected private var ai: AIService
    
    init() {
        //        self.service = AsyncDataService()
    }
    
    func getArtists() {
        isLoading = true
        AsyncDataService.fetchAlbums { [unowned self] result in
            
            switch result {
            case .success(let artists):
                
                // Update UI using main thread
                DispatchQueue.main.async {
                    
                    // Update collection view content
                    self.artists.removeAll()
                    self.artists.append(contentsOf: artists)
                    self.isLoading = false
                    //                    updateCollectionViewSnapshot(albums)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                self.isLoading = false
                
            }
        }
    }
    
    func getArtistsV2() {
        self.isLoading = true
        Task {
            
            do {
                
                let artists = try await AsyncDataService.fetchArtistWithContinuation()
                
                // Update collection view content
                self.artists.removeAll()
                self.artists.append(contentsOf: artists)
                self.isLoading = false
                
            } catch {
                self.isLoading = false
                print("Request failed with error: \(error)")
            }
            
        }
        
    }
    
    func getArtistsV3() {
        self.isLoading = true
        
        Task {
            do {
                
                let albums = try await AsyncDataService.fetchArtistsWithAsyncURLSession()
                
                // Update collection view content
                self.artists.removeAll()
                self.artists.append(contentsOf: albums)
                self.isLoading = false
                
            } catch {
                self.isLoading = false
                print("Request failed with error: \(error)")
            }
            
        }
    }
    
    func getAIReq() {
        self.isLoading = true
        let chat = Chat(role: Chat.Role.assistant, content: "Send test reply")
        let query = ChatQuery(model: Model.gpt3_5Turbo, messages: [chat])
        Task {
            do {
                for try await result in try await ai.getChat().chatsStream(query: query) {
                    if result.choices.count > 0 {
                        let choice = result.choices[0]
                        if choice.finishReason == nil {
                            textData = textData.appending(choice.delta.content ?? ".")
                        } else {
                            self.isLoading = false
                        }
//                        print("Choice: \(choice)")
                    }
//                    print("Data: \(result)")
                }
                
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    let textToType = "Hello, World!"
    var currentIndex = 0
    
    func startSetText() {
        textData = ""
        currentIndex = 0
        setText()
    }
    
    func setText() {
        Task {
            if currentIndex < textToType.count {
                let index = textToType.index(textToType.startIndex, offsetBy: currentIndex)
                textData = String(textToType[...index])
                currentIndex += 1
                
                try await Task.sleep(nanoseconds: 1_000_000_00)
                self.setText()
            }
        }
    }
}
