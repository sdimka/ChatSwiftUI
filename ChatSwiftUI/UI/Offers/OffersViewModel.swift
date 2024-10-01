//
//  OffersViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 22.09.2024.
//

import Foundation
import SwiftUI
import Resolver


enum OffersError: Error, Identifiable, Equatable {
    case networkError(String)
    case decodingError(String)
    case unknownError(String)

    var id: String { localizedDescription }

    var localizedDescription: String {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}

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
    
    var currentError: OffersError?
    
    init(){
        update()
    }
    
    func update() {
        loaded = true
        Task {
            do {
                offers = try await service.getJobOffers(filter: selectedFilter.fValue)
                try await Task.sleep(nanoseconds: 5_000_000_00)
                
            } catch let error as JobOfferError {
                currentError = mapError(error)
                offers = []
            } catch {
                currentError = .unknownError(error.localizedDescription)
                offers = []
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
            } catch let error as JobOfferError {
                currentError = mapError(error)
            } catch {
                currentError = .unknownError(error.localizedDescription)
            }
            loaded = false
        }
    }

    func setOfferStatus(offer: JobOffer, status: Int) {
        loaded = true
        let newOffer = offer.copy(status: status)
        updateOffer(offer: newOffer)
    }

    func dismissError() {
        currentError = nil
    }
    
    private func mapError(_ error: JobOfferError) -> OffersError {
        switch error {
        case .invalidURL:
            return .networkError("Invalid API URL")
        case .networkError(let underlyingError):
            return .networkError(underlyingError.localizedDescription)
        case .decodingError(let underlyingError):
            if let decodingError = underlyingError as? DecodingError {
                return parseDecodingError(decodingError)
            } else {
                return .decodingError("Unknown decoding error: \(underlyingError.localizedDescription)")
            }
        case .invalidResponse:
            return .networkError("Invalid server response")
        }
    }
    
    private func parseDecodingError(_ error: DecodingError) -> OffersError {
        let errorDescription: String
        switch error {
        case .keyNotFound(let key, let context):
            errorDescription = "Key not found: '\(key)'\nDescription: \(context.debugDescription)\nCoding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
        case .valueNotFound(let value, let context):
            errorDescription = "Value not found: '\(value)'\nDescription: \(context.debugDescription)\nCoding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
        case .typeMismatch(let type, let context):
            errorDescription = "Type mismatch: Expected '\(type)'\nDescription: \(context.debugDescription)\nCoding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
        case .dataCorrupted(let context):
            errorDescription = "Data corrupted\nDescription: \(context.debugDescription)\nCoding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
        @unknown default:
            errorDescription = "Unknown decoding error"
        }
        
        return .decodingError(errorDescription)
    }
}
