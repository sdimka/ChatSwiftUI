//
//  ExpandableText.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 24.09.2024.
//

import Foundation
import SwiftUI


struct ExpandableText: View {
    private let text: String
    private let lineLimit: Int
    
    @State private var truncated: Bool = false
    @State private var expanded: Bool = false
    
    init(_ text: String, lineLimit: Int) {
        self.text = text
        self.lineLimit = lineLimit
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            Text (text)
                .lineLimit(expanded ? nil : self.lineLimit)
                .background (
                    Text(text).lineLimit(self.lineLimit)
                        .background (GeometryReader { visibleTextGeometry in
                            ZStack { //large size zstack to contain any size of text
                                Text(self.text)
                                    .background (GeometryReader { fullTextGeometry in
                                        Color.clear.onAppear {
                                            self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                        }
                                    })
                            }.frame (height: .greatestFiniteMagnitude)
                        }).hidden() //keep hidden
                )
            if truncated && !expanded {
                HStack {
                    Button(action: {
                        withAnimation(.easeIn){
                            expanded.toggle()
                        }
                    }, label: {
                        Text("more")
                    }).buttonStyle(.borderless)
                    
                    Spacer()
                }
            } else {
                HStack {
                    Button(action: {
                        withAnimation(.easeOut){
                            expanded.toggle()
                        }
                    }, label: {
                        Text("less")
                    }).buttonStyle(.borderless)
                    
                    Spacer()
                }
            }
        }
    }
}
