import Foundation
import Resolver

enum JobOfferError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

class JobOfferService {
    
    @Injected private var db: DBService
    @Injected private var authInterceptor: AuthInterceptor
    
    func getJobOffers(filter: Int) async throws -> [JobOffer] {
        let baseURL = try await getBaseURL()
        let filterString = filter != 99 ? "?status=\(filter)" : ""
        
        guard let url = URL(string: "\(baseURL)/jobs/\(filterString)") else {
            throw JobOfferError.invalidURL
        }

        var request = URLRequest(url: url)
        request = try await authInterceptor.intercept(request)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([JobOffer].self, from: data)
        } catch let error as DecodingError {
            throw JobOfferError.decodingError(error)
        } catch {
            throw JobOfferError.networkError(error)
        }
    }
    
    private func getBaseURL() async throws -> String {
        do {
            let param = try await db.getParam(by: .apiAdress)
            return param.value
        } catch DBErrors.notFound {
            throw JobOfferError.invalidURL
        } catch {
            throw JobOfferError.networkError(error)
        }
    }
}
