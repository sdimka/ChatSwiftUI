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
        VStack {
            HStack {
                leftColumnView
                Spacer().frame(minWidth: 20, maxWidth: 25)
                rightColumnView
            }
            
            saveButton
            
            Spacer()
        }
        .padding()
        .task {
            viewModel.update()
        }
    }
    
    private var leftColumnView: some View {
        VStack {
            settingsRow(title: "AI API Key", binding: $viewModel.apiKey, icon: "key.horizontal")
            settingsRow(title: "API Model", binding: $viewModel.apiModel, icon: "figure.walk.diamond")
            dbPathRow
        }
    }
    
    private var rightColumnView: some View {
        VStack(alignment: .trailing, spacing: 16) {
            settingsRow(title: "API Address", binding: $viewModel.apiAdress, icon: "key.horizontal")
            settingsRow(title: "API User", binding: $viewModel.apiUser, icon: "figure.walk.diamond")
            HStack {
                Text("API Pass")
                SecureField("API Pass", text: $viewModel.apiPassword)
                    .frame(width: 350)
            }
        }
    }
    
    private var dbPathRow: some View {
        HStack {
            Text("DB Path:")
            Text(viewModel.dbPath)
                .textSelection(.enabled)
                .frame(width: 350)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.save()
        }) {
            Label("SAVE", systemImage: "square.and.arrow.down")
        }
        .padding(.top)
    }
    
    private func settingsRow(title: String, binding: Binding<String>, icon: String) -> some View {
        HStack {
            Text(title)
            TextField(text: binding) {
                Label(title, systemImage: icon)
            }
            .frame(width: 350)
        }
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
