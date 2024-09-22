//
//  OffersViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 22.09.2024.
//

import Foundation
import SwiftUI
import Resolver


@Observable
class OffersViewModel {
    
    @ObservationIgnored
    @Injected private var db: DBService
    @ObservationIgnored
    @Injected private var service: JobOfferService
    
    var offers: [JobOffer] = []
    
    func update() {
        Task {
            do {
                try await offers = service.getJobOffers()
                
            } catch {
                print(error)
            }
        }
    }
    
}
