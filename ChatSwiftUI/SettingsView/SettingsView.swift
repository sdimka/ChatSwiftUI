//
//  SettingsView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {

    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack (alignment: .trailing){
            Spacer()
            HStack {
                Text("API Key")
                TextField(text: $viewModel.apiKey, 
                          label: { Label("API Key", systemImage: "key.horizontal")})
                .frame(width: 350)
            }
            
            HStack {
                Text("API Model")
                TextField(text: $viewModel.apiModel, 
                          label: { Label("API Model", systemImage: "figure.walk.diamond")})
                .frame(width: 350)
            }
            
            HStack {
                Text("DP Path:")
                Text(viewModel.dbPath).textSelection(.enabled)
                .frame(width: 350)
            }
            
            Button(action: {
                viewModel.save()
            }, label: {
                Label("SAVE", systemImage: "square.and.arrow.down")
            }).padding(.top)
            
        }.padding()
            .task {
                viewModel.update()
            }
        
        Text("Settings View")
            .font(.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mint.opacity(0.5))
            .navigationTitle("Settings")
    }
}

//extension View {
//    public func removeFocusOnTap() -> some View {
//        modifier(RemoveFocusOnTapModifier())
//    }
//}
//
//
//public struct RemoveFocusOnTapModifier: ViewModifier {
//    public func body(content: Content) -> some View {
//        content
//#if os (iOS)
//            .onTapGesture {
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
//            }
//#elseif os(macOS)
//            .onTapGesture {
//                DispatchQueue.main.async {
//                    NSApp.keyWindow?.makeFirstResponder(nil)
//                }
//            }
//#endif
//    }
//}
