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
    var loaded: Bool = false
    
    func update() {
        loaded = true
        Task {
            do {
                try await offers = service.getJobOffers()
                try await Task.sleep(nanoseconds: 5_000_000_00)
                
            } catch {
                print(error)
            }
            loaded = false
        }
    }
    
}
