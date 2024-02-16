//
//  AdvancedList.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI

struct AdvancedList<Data: RandomAccessCollection & MutableCollection & RangeReplaceableCollection,
    Content: View>: View where Data.Element: Identifiable {
    
    @Binding var data: Data
    var content: (Binding<Data.Element>) -> Content

    init(_ data: Binding<Data>,
         content: @escaping (Binding<Data.Element>) -> Content) {
        self._data = data
        self.content = content
    }

    var body: some View {
        List {
            ForEach($data, content: content)
                .onMove { indexSet, offset in
                    data.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete { indexSet in
                    data.remove(atOffsets: indexSet)
                }
        }
        .toolbar { Button(action: signIn) {
            Text("Sign In")
        } }
    }
    
    func signIn() {
        print("Some test")
    }
}
