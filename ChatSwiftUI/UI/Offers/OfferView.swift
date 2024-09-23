//
//  OfferView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 23.09.2024.
//

import SwiftUI

struct OfferView: View {
    
    @State var jobOffer: JobOffer?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 10)
                
            VStack(alignment:.leading) {
                Text((jobOffer?.addDate.ISO8601Format())!)
                    .font(.custom("SFMono-Regular", fixedSize: 9))
                    .foregroundStyle(.gray)
                    .padding([.leading, .top], 10)
                HStack {
                    Text(jobOffer!.title)
                        .font(.custom("SFMono-Bold", fixedSize: 16))
                        .textSelection(.enabled)
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(jobOffer!.url, forType: .string)
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 20, height: 20)
                            .padding([.top, .bottom], 5)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.up.forward.app")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 20, height: 20)
                            .padding([.top, .bottom], 5)
                    }.padding(.trailing, 20)
                }
                
                Text(jobOffer!.description)
                    .font(.custom("SFMono-Regular", fixedSize: 14))
                    .lineLimit(3, reservesSpace: true)
                    .padding(.horizontal, 10)
                
                HStack {
                    Text(paymentType(jobOffer!.payment))
                        .font(.custom("SFMono-Regular", fixedSize: 9))
                        .foregroundStyle(.gray)
                        .padding(.leading, 10)
                    Text(jobOffer!.spendings)
                        .font(.custom("SFMono-Regular", fixedSize: 9))
                        .foregroundStyle(.gray)
                        .padding(.leading, 10)
                    Text(jobOffer!.country)
                        .font(.custom("SFMono-Regular", fixedSize: 9))
                        .foregroundStyle(.gray)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(jobOffer!.url, forType: .string)
                    } label: {
                        Image(systemName: "hand.thumbsup")
                            .resizable(resizingMode: .stretch)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .frame(width: 20, height: 20)
                            .padding([.top, .bottom], 5)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "hand.thumbsdown")
                            .resizable(resizingMode: .stretch)
                            .foregroundColor(.red)
                            .frame(width: 20, height: 20)
                            .padding([.top, .bottom], 5)
                    }.padding(.trailing, 20)
                    
                }
                .padding()
            }
            
        }
        .padding(15)
        .listRowSeparator(.hidden)
    }
                         
    func paymentType(_ strData: String) -> String {
        if strData == "0" { return "not verified" }
        return "verified"
    }
    
}
