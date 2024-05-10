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
    
    var body: some View {
        HStack {
            if selectedChat == record.id {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }

            Text(record.name).frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                //                viewModel.save()
            } label: {
                Image(systemName: "square.and.arrow.down")
            }.frame(maxWidth: .infinity, alignment: .trailing)
            
        }.padding()
            .onTapGesture {
                self.selectedChat = self.record.id
        }
    }
}
