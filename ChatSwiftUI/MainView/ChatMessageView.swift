//
//  ChatMessageView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI

struct ChatMessageView: View {
    
//    @Binding var record: CHRecord
    var messageText: String
    var sender: Int
    
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35)
                .foregroundColor(sender == 1 ? .chIcon1 : .chIcon2)
            Text(messageText)
                .font(.custom(
                    "SFMono-Regular",
                    fixedSize: 15))
                .textSelection(.enabled)
                .padding()
                .background(.chBack)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.chBack)
                        .offset(x: -10, y: -10)
                }
        }.listRowSeparator(.hidden)
    }
}
