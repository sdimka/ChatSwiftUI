//
//  MainView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel = MainViewModel()
    var radius = 50.0
    let animation = Animation.easeInOut(duration: 1) //.repeatForever(autoreverses: false)
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - List
            ScrollViewReader { scrollProxy in
                List(viewModel.chRecords, id: \.self) { record in
                    ChatMessageView(messageText: record.body, sender: record.sender)
                }.listStyle(.plain)
                    .onChange(of: viewModel.chRecords, {
                            withAnimation {
                                scrollProxy.scrollTo(viewModel.chRecords.last!, anchor: .bottom)
                            }
                    })
                    .onReceive(viewModel.vm.$direction) { action in
                        guard !viewModel.chRecords.isEmpty else { return }
                        withAnimation {
                            switch action {
                            case .top :
                                scrollProxy.scrollTo(viewModel.chRecords.first!, anchor: .top)
                            case .end:
                                scrollProxy.scrollTo(viewModel.chRecords.last!, anchor: .bottom)
                            default:
                                return
                            }
                        }
                    }
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
                                viewModel.vm.direction = .end
                            }, label: {
                                Image(systemName: "plus.app")
                            })
                            
                        }
                    }
            }
            // MARK: - Answer element

                if viewModel.isOn {
                    HStack {
                        ProgressView()
                            .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
                            .padding()
                            .transition(.opacity)
                        
                        Text(viewModel.answerText)
                            .font(.custom(
                                "SFMono-Regular",
                                fixedSize: 14))
                            .textSelection(.enabled)
                            .padding()
                            .background(.chBack)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                        
                    }.background(.white)
                        
                }
            
            // MARK: - Edit field
            HStack {
                TextEditor(text: $viewModel.editText)
                    .font(.custom(
                        "SFMono-Regular",
                        fixedSize: 14))
                    .frame(height: 150)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .navigationTitle("About you")
                VStack {
                    Button {
//                        viewModel.insertRecord()
                        viewModel.sendAIReq()
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
            }.background(.chBack)
        }.background(.white)
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

class ScrollToModel: ObservableObject {
    enum Action {
        case end
        case top
    }
    @Published var direction: Action? = nil
}
