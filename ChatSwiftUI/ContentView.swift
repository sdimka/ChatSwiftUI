//
//  ContentView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 13.02.2024.
//

import SwiftUI
import Resolver

struct Option: Hashable {
    let title: String
    let imageName: String
    let item: Item
    
}

enum Item: String {
    case first
    case second
    case third
    case fourth
}

struct ContentView: View {
    
    let nsObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    @State var currentOption: Item? = .first
    
    let options: [Option] = [
        .init(title: "Home", imageName: "house", item: .first),
        .init(title: "About", imageName: "info.circle", item: .second),
        .init(title: "Settings", imageName: "gear", item: .third),
        .init(title: "Tests", imageName: "bolt.shield", item: .fourth),
    ]
    
    var body: some View {
        NavigationSplitView {
            SidebarView(options: options, currentSelection: $currentOption)
//            List(options, id: \.self, selection: $currentOption) { option in
//                NavigationLink(value: option.item, label: { Label(option.title, systemImage: option.imageName) })
//
            Text("ver: \(nsObject ?? "No ver info")").padding()
          
        } detail: {
            if let dest = currentOption {
                switch dest {
                case .first:
                    Resolver.main.resolve(MainView.self)
                case .second:
                    Resolver.main.resolve(SecondColumnView.self)
                case .third:
                    Resolver.main.resolve(SettingsView.self)
                case .fourth:
                    Resolver.main.resolve(TestView.self)
                }
            }

        }
        .frame(minWidth: 600, minHeight: 700)
    }
}

struct SecondColumnView: View {
    var body: some View {
        VStack {
            Text("Second Column View")
                .font(.title)

            NavigationLink("Open Next View") {
                SettingsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.opacity(0.3))
        .navigationTitle("Second Navigation Title")
    }
}

struct EditTextModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
      VStack(spacing: 50) {
        Text("Information view.")
          .font(.largeTitle)
        
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Label("Close", systemImage: "xmark.circle")
        })
      }
    }
}

//#Preview {
//    ContentView()
//}
