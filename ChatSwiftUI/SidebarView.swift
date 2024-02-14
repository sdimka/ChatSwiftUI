//
//  SidebarView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 13.02.2024.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    let options: [Option]
    @Binding var currentSelection: Item?
    
    var body: some View {
        VStack {
            List(options, id: \.self, selection: $currentSelection) { option in
                NavigationLink(value: option.item, 
                               label: { Label(option.title, systemImage: option.imageName)})
                .padding()
            }
//            ForEach(options, id: \.self) { option in
//                HStack {
//                    Button(action: {
//                        print("Some text")
//                    } ){
//                        Image(systemName: option.imageName)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 25)
//                        Text(option.title)}
//                NavigationLink(option.title, value: option)
//                NavigationLink(value: option.title, label: { Label(option.title, systemImage: option.imageName) })

//                Spacer()
//                }
//                .padding( )
//            }
//            Spacer()
        }
    }
}
