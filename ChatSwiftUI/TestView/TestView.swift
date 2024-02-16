//
//  TestView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 16.02.2024.
//

import Foundation
import SwiftUI


struct TestView: View {
    
    @StateObject private var viewModel = TestViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.textData)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.5))
                .navigationTitle("Test View Navigation Title")
            HStack {
                Button {
                    viewModel.getArtistsV2()
                } label: {
                    Text("GET DATA")
                        .frame(width: 250, height: 40)
                }
                .buttonStyle(.bordered)
                .padding()
                
                Button {
                    viewModel.getAIReq()
//                    viewModel.startSetText()
                } label: {
                    Text("SOME BUTTON")
                        .frame(width: 250, height: 40)
                }
                .buttonStyle(.bordered)
                .padding()
            }
            List(viewModel.artists, id: \.self) { record in
                Text(record.title)
                
            }
            if viewModel.isLoading {
                ProgressView().padding()
            }
        }
    }
}
