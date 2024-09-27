//
//  SelectorView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 24.09.2024.
//

import Foundation
import SwiftUI


enum FilterMode: Int, CaseIterable {
    case new
    case liked
    case disliked
    case all

    var imageName: String {
        switch self {
        case .new:
            return "newspaper.circle.fill"
        case .liked:
            return "hand.thumbsup"
        case .disliked:
            return "hand.thumbsdown"
        case .all:
            return "wallet.pass"
        }
    }

    var title: String {
        switch self {
        case .new:
            return "New"
        case .liked:
            return "Liked"
        case .disliked:
            return "Disliked"
        case .all:
            return "All"
        }
    }
    
    var fValue: Int {
        switch self {
        case .new:
            return 0
        case .liked:
            return 2
        case .disliked:
            return 1
        case .all:
            return 99
        }
    }
}

struct SelectorView: View {
    
    @Binding var selectedFilter: FilterMode
    let color = Color.indigo
    
    init(selectedFilter: Binding<FilterMode>) {
        self._selectedFilter = selectedFilter
    }

    var body: some View {
        VStack {
            filterSelector
                .padding(12)
                .background(backgroundView)
                .padding(.horizontal, 25)
                .animation(.smooth, value: selectedFilter)
        }
    }

    private var filterSelector: some View {
        HStack(spacing: 0) {
            ForEach(FilterMode.allCases.indices, id: \.self) { index in
                let mode = FilterMode.allCases[index]
                let makeDivider = index < FilterMode.allCases.count - 1

                Button {
                    selectedFilter = mode
                } label: {
                    VStack(spacing: 7) {
                        Image(systemName: mode.imageName)
                            .font(.title2)
                        Text(mode.title)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .padding(.vertical, 13)
                    .contentShape(Rectangle())
                }
                .buttonStyle(BouncyButton())

                if makeDivider {
                    if !(index == selectedFilter.rawValue || (index + 1) == selectedFilter.rawValue) {
                        Divider()
                            .frame(width: 0, height: 35)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 2)
        .background(selectorBackground)
    }

    private var selectorBackground: some View {
        GeometryReader { proxy in
            let caseCount = FilterMode.allCases.count
            color.opacity(0.1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: proxy.size.width / CGFloat(caseCount))
                .offset(x: proxy.size.width / CGFloat(caseCount) * CGFloat(selectedFilter.rawValue))
        }
    }

    private var backgroundView: some View {
        Color(.white)
            .opacity(0.6)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.primary.opacity(0.08), lineWidth: 1.2))
    }

}

struct BouncyButton: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .scaleEffect(x: configuration.isPressed ? 0.95 : 1.0, y: configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}



//struct SelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectorView()
//    }
//}
