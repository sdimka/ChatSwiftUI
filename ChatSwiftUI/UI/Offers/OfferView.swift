//
//  OfferView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 23.09.2024.
//

import SwiftUI

struct OfferView: View {
    
    @State var jobOffer: JobOffer?
    var setStatus: (JobOffer, Int) -> Void
    @Environment(\.openURL) var openLink
    
    var paymentVerificationColor: Color {
        jobOffer?.client.paymentVerificationStatus == true ? .green : .gray
    }
    
    var paymentVerificationText: String {
        jobOffer?.client.paymentVerificationStatus == true ? "verified" : "not verified"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 10)
                
            VStack(alignment:.leading) {
                Text((jobOffer?.addDate.ISO8601Format())!)
                    .font(.custom("SFMono-Regular", fixedSize: 10))
                    .foregroundStyle(.gray)
                    .padding(.top, 10)
                    .padding(.leading, 25)
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
                        guard let url_link = URL(string:jobOffer!.url) else {
                            return
                        }
                        openLink(url_link)
                    } label: {
                        Image(systemName: "arrow.up.forward.app")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 20, height: 20)
                            .padding([.top, .bottom], 5)
                    }.padding(.trailing, 20)
                }
                
                offerPayment()

                ExpandableText(jobOffer!.description, lineLimit: 3)
                    .font(.custom("SFMono-Regular", fixedSize: 14))
                    .padding(.horizontal, 15)
                    .textSelection(.enabled)
                
                NewFlowLayout(alignment: .leading) {
                    ForEach(jobOffer!.tags) { tag in
                        Text(tag.name)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.3))
                                )
                    }
                }.padding(.horizontal, 15)
                             
                
                HStack {
                    
                    Image(systemName: "dollarsign.square")
                        .foregroundStyle(paymentVerificationColor)
                        .padding(.leading, 10)
                    Text(paymentVerificationText)
                        .font(.custom("SFMono-Regular", fixedSize: 10))
                        .foregroundStyle(.gray)
                    
                    Text(String(format: "%.2f", jobOffer!.client.totalSpent))
                        .font(.custom("SFMono-Regular", fixedSize: 10))
                        .foregroundStyle(.gray)
                        .padding(.leading, 10)
                    
                    Text(CountryFlags.findFlag(for: jobOffer!.client.country))
                        .padding(.leading, 10)
                    Text(jobOffer!.client.country)
                        .font(.custom("SFMono-Regular", fixedSize: 10))
                        .foregroundStyle(.gray)

                    RatingView(value: jobOffer?.client.totalFeedback ?? 0)
                        .padding(15)
                    
                    Spacer()
                    
                    Button {
                        setStatus(jobOffer!, FilterMode.liked.fValue)
                    } label: {
                        Image(systemName: "hand.thumbsup")
                            .resizable(resizingMode: .stretch)
                            .foregroundColor(.blue)
                            .frame(width: 20, height: 20)
                            .padding([.top, .bottom], 5)
                    }
                    
                    Button {
                        setStatus(jobOffer!, FilterMode.disliked.fValue)
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
                         
    private func offerPayment() -> some View {
        
        return HStack {
            if let jobOffer = jobOffer {
                if jobOffer.jobType == 1 {
                    Text("Fixed price")
                        .font(.custom("SFMono-Regular", fixedSize: 14))
                        .foregroundColor(.gray)
                    if let amount = jobOffer.amount {
                        Text("$\(amount, specifier: "%.2f")")
                            .font(.custom("SFMono-Bold", fixedSize: 14))
                            .foregroundColor(.gray)
                    }
                } else if jobOffer.jobType == 2 {
                    Text("Hourly price")
                        .font(.custom("SFMono-Regular", fixedSize: 14))
                        .foregroundColor(.gray)
                    if let hourlyBudget = jobOffer.hourlyBudget {
                        Text("$\(hourlyBudget)")
                            .font(.custom("SFMono-Bold", fixedSize: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
    
}
