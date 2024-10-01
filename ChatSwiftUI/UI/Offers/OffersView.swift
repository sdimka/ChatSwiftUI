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
    
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack(alignment: .center) {
                
                SelectorView(selectedFilter: $viewModel.selectedFilter)
                    .frame(width: 600)
                
                Spacer()
                
                Button {
                    viewModel.update()
                } label: {
                    Image(systemName: "arrow.clockwise.square")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 20, height: 20)
                        .padding([.top, .bottom], 5)
                }.padding(.trailing, 20)
            }
            
            
            List(viewModel.offers, id: \.self) { record in
                OfferView(jobOffer: record, setStatus: viewModel.setOfferStatus)
            }.listSectionSeparator(.hidden)
        }
        .overlay(alignment: .center){
            if (viewModel.loaded) {
                LottieView(lottieFile: "loaded-j", loopMode: .loop)
                    .frame(width: 100, height: 100, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.3))
        .navigationTitle("Second Navigation Title")
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Error!"), 
                message: Text(viewModel.currentError?.localizedDescription ?? "No description"),
                dismissButton: .default(Text("OK")) {
                    viewModel.dismissError()
                }
            )
        }
        .onChange(of: viewModel.currentError, {
            showingAlert = (viewModel.currentError != nil)
        })
    }
}
