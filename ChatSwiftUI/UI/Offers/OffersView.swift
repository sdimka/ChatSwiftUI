//
//  OffersView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 22.09.2024.
//

import Foundation
import SwiftUI
import Resolver


struct OffersView: View {
    
    @State private var viewModel = Resolver.resolve(OffersViewModel.self)
    
    var body: some View {
        VStack {
            Text("Second Column View")
                .font(.title)

            Button(action: {
                viewModel.update()
            }, label: {
                Image(systemName: "network")
            })
            Divider()
            List(viewModel.offers, id: \.self) { record in
                Text(record.title)
            }.listSectionSeparator(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.opacity(0.3))
        .navigationTitle("Second Navigation Title")
    }
}
