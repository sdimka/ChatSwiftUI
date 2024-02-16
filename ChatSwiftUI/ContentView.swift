//
//  ContentView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 13.02.2024.
//

import SwiftUI

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
    
    @State var currentOption: Item? = .first
    
    let options: [Option] = [
        .init(title: "Home", imageName: "house", item: .first),
        .init(title: "About", imageName: "info.circle", item: .second),
        .init(title: "Settings", imageName: "gear", item: .third),
        .init(title: "Social", imageName: "message", item: .fourth),
    ]
    
    var body: some View {
        NavigationSplitView {
            SidebarView(options: options, currentSelection: $currentOption)
//            List(options, id: \.self, selection: $currentOption) { option in
//                NavigationLink(value: option.item, label: { Label(option.title, systemImage: option.imageName) })
//            }
          
        } detail: {
            if let dest = currentOption {
                switch dest {
                case .first:
                    MainView()
                case .second:
                    SecondColumnView()
                case .third:
                    SettingsView()
                case .fourth:
                    TestView()
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

//#Preview {
//    ContentView()
//}
