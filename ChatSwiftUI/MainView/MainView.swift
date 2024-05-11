//
//  MainView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI
import Resolver

struct MainView: View {
    
    @State private var viewModel = Resolver.resolve(MainViewModel.self)
//    @State private var chatSelection: Int?
    @State var showInfoModalView: Bool = false
    
    var body: some View {
        HStack() {

            chatSelector()
            Divider()
            VStack(alignment: .leading) {
                chatBody()
                
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
                
                messageEditPart()
            }
        }
        .background(.white)
        .navigationTitle("MainView Title")
        .frame(alignment: .trailing)
        .alert(isPresented: $viewModel.errorEnable) {
            Alert(title: Text("Error!"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
        .sheet(isPresented: $showInfoModalView) {
            EditTextModalView()
        }
        .task {
            viewModel.loadHistory()
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
                    Image(systemName: "chevron.down")
                })
                
            }
        }
    }
    
    private func chatSelector() -> some View {
        VStack {
            List(viewModel.chats, id: \.self) { record in
                ChatSelectorView(record: record, selectedChat: $viewModel.selectedChart)
            }.listSectionSeparator(.hidden)
            
            Divider()
            
            Text("You selected \(viewModel.selectedChart)").padding()

            
        }.frame(maxWidth: 200)
            
        
    }
    
    private func chatBody() -> some View {
        ScrollViewReader { scrollProxy in
            List(viewModel.chRecords, id: \.self) { record in
                // ChatMessageView(messageText: record.body, sender: record.sender)
                ChatMessageView(record: record)
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
        }
    }
    
    private func messageEditPart() -> some View {
        HStack {
            ZStack(alignment: .bottom) {
                Color.gray.opacity(0.3).clipShape(RoundedRectangle(cornerRadius: 12))
                
                TextEditor(text: $viewModel.editText)
                    .font(.custom(
                        "SFMono-Regular",
                        fixedSize: 14))
                    .frame(minHeight: 50)
                    .cornerRadius(12)
                //                            .border(.black)
                    .padding(3)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            print("Button pressed")
                            showInfoModalView = true
                        }, label: {
                            Image(systemName: "rectangle.expand.vertical")
                            
                        }).offset(x: -18, y: 18)
                    }
            }
            VStack {
                Button {
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
            
        }.frame(maxHeight: 150)
            .padding()
    }
}

class ScrollToModel: ObservableObject {
    enum Action {
        case end
        case top
    }
    @Published var direction: Action? = nil
}
