//
//  ChatSelectorView.swift
//  ChatSwiftUI
//
//  Created by  Dmitriy on 10.05.2024.
//

import Foundation
import SwiftUI

struct ChatSelectorView: View {
    
    @State var record: Chat
    @Binding var selectedChat: Int?
    @State private var selectedFruit = "Apple"
    @State private var picker = false
    let fruits = ["Apple", "Banana", "Cherry"]
    
    var body: some View {

        HStack {
            HStackLayout{
                
                Text(record.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
    
                Menu {
                    Button {
                    } label: {
                        Label("Edit Name", systemImage: "rectangle.stack.badge.plus")
                    }
                    Button {
                    } label: {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }
                    Button {
                    } label: {
                        Label("Delete", systemImage: "rectangle.stack.badge.person.crop")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .frame(maxWidth: 30, alignment: .trailing)
            }
        }.background(getColor(sc: selectedChat))
            .cornerRadius(8)
            .listStyle(.plain)
            .onTapGesture {
                self.selectedChat = self.record.id
            }
    }
    
    private func getColor(sc: Int?) -> Color {
        if selectedChat == record.id {
            return Color.chBack
        }
        return Color.white
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let chat = Chat(id: 1, name: "First", icon: "")
        @State var isShowing: Int? = 1
        ChatSelectorView(record: chat, selectedChat: $isShowing)
    }
}
