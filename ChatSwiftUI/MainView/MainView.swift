//
//  MainView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            List(viewModel.chRecords, id: \.self) { record in
                ChatMessageView(messageText: record.body, sender: record.sender)
            }.listStyle(.plain)
            .toolbar {
                ToolbarItem(id: "clockwise", placement: .automatic, showsByDefault: true) {
                    Button(action: {
                        viewModel.loadHistory()
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                }
                ToolbarItem(id: "plus_rnd", placement: .automatic, showsByDefault: true) {
                    Button(action: {
                        viewModel.sendRequest()
                    }, label: {
                        Image(systemName: "plus.app")
                    })

                }
            }
            if viewModel.isLoading {
                HStack {
                    Text("Some other text")
//                        .alignmentGuide(.leading, computeValue: { d in d[.leading]})
                    Spacer()
                    ProgressView()
//                        .alignmentGuide(.trailing, computeValue: { d in d[.trailing]})
                        .padding()
                        .transition(.opacity)
                }
            }
            
            HStack {
                TextEditor(text: $viewModel.editText)
                    .font(.custom(
                        "SFMono-Regular",
                        fixedSize: 15))
                    .frame(height: 150)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .navigationTitle("About you")

                    Button {
                        viewModel.insertRecord()
                    } label: {
                        Text("SEND")
                            .frame(width: 150, height: 40)
                    }
                    .disabled(viewModel.sendEnable)
                    .buttonStyle(.bordered)
                    .padding()
                
                    Button {
                        viewModel.editRecord()
                    } label: {
                        Text("Test")
                            .frame(width: 150, height: 40)
                    }
                    .buttonStyle(.bordered)
                    .padding()
            }
        }
        .navigationTitle("MainView Title")
        .frame(alignment: .trailing)
        .alert(isPresented: $viewModel.errorEnable) {
            Alert(title: Text("Error!"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
        .task {
                viewModel.loadHistory()
            }
        
    }
}
