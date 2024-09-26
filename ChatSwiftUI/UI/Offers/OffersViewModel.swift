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
    
    var selectedFilter: FilterMode = .new {
        willSet(newVal) {
            onFilterSelect(filterType: newVal)
        }
    }
    
    init(){
        update()
    }
    
    func update() {
        loaded = true
        Task {
            do {
                try await offers = service.getJobOffers(filter: selectedFilter.fValue)
                try await Task.sleep(nanoseconds: 5_000_000_00)
                
            } catch {
                print(error)
            }
            loaded = false
        }
    }
    
    private func onFilterSelect(filterType: FilterMode) {
        update()
    }
    
    func updateOffer(offer: JobOffer) {
        Task {
            do {
                try await service.updateJobOffer(jobOffer: offer)
                update()
            } catch {
                loaded = false
                print(error)
            }
        }
    }

    func setOfferStatus(offer: JobOffer, status: Int) {
        loaded = true
        let newOffer = offer.copy(status: status)
        updateOffer(offer: newOffer)
    }
}
