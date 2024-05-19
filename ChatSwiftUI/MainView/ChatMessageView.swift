//
//  ChatMessageView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI

struct ChatMessageView: View {
    
    @State var record: CHRecord?
    var onDelete: (CHRecord) -> Void
    @State var overRecordAnim = false
    @State var overRecord : Bool = false {
            didSet {
                withAnimation {
                    if overRecord {
                        overRecordAnim = true
                    }
                    else {
                        overRecordAnim = false
                    }
                }
            }
        }
    
    var body: some View {
        HStack {
            HStackLayout{
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                    .foregroundColor(record!.sender == 1 ? .chIcon1 : .chIcon2)
                Text(record!.body)
                    .font(.custom(
                        "SFMono-Regular",
                        fixedSize: 14))
                    .textSelection(.enabled)
                    .frame(maxWidth: 900, alignment: .leading)
                    .padding()
                    .background(.chBack)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundColor(.chBack)
                            .offset(x: -10, y: -10)
                    }
            }
//            .frame(maxWidth: 900, alignment: .leading)

            
//            if overRecordAnim {
            ChatMessagePopView(item: record!, isVisible: $overRecordAnim, onDelete: onDelete)
//                .frame(maxWidth: 120, alignment: .leading)
//            }
        }
        .listRowSeparator(.hidden)
            .onHover(perform: { hovering in
                overRecord = hovering
            })
//            .popover(item: $record) { itm in
//                    
//            }
    }
}

struct ChatMessagePopView: View {
    var item: CHRecord
    @Binding var isVisible: Bool
    var onDelete: (CHRecord) -> Void
    
    var body: some View {
        HStack {
            if isVisible {
                VStack(alignment: .leading) {
//                    Image(systemName: "seal.fill")
//                    Text("\(item.sender)")
                    Text(strFromInt("compl: ", item.usage?.completionTokens))
                    Text(strFromInt("prompt: ", item.usage?.promptTokens))
                    Text(strFromInt("total: ", item.usage?.totalTokens))
                }
                .foregroundColor(.blue)
                Text("\(item.id)")
                Image(systemName: "xmark.bin").onTapGesture{
                    onDelete(item)
                }
            }
        }
        .frame(maxWidth: 130, alignment: .leading)
    }
    
    func strFromInt(_ pref: String, _ value: Int?) -> String {
        guard let value = value, value != 0 else {
            return ""
        }
        return pref + String(value)
    }
}
