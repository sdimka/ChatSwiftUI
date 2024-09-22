//
//  AuthInterceptor.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 22.09.2024.
//

import Foundation
import Resolver

class AuthInterceptor {
    @Injected private var db: DBService
    private var token: String?
    private var tokenExpirationDate: Date?
    
    func intercept(_ request: URLRequest) async throws -> URLRequest {
        if let token = token, let expirationDate = tokenExpirationDate, expirationDate > Date() {
            return addAuthorizationHeader(to: request, with: token)
        }
        
        // Token is missing or expired, fetch a new one
        let newToken = try await fetchToken()
        return addAuthorizationHeader(to: request, with: newToken)
    }
    
    private func fetchToken() async throws -> String {
        let baseURL = try await getBaseURL()
        guard let url = URL(string: "\(baseURL)/token") else {
            throw AuthError.invalidURL
        }
        
        let credentials = try await getCredentials()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = [
            "email": credentials.username,
            "password": credentials.password
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            
            self.token = tokenResponse.accessToken
            self.tokenExpirationDate = tokenResponse.expiresIn
            
            return tokenResponse.accessToken
        } catch {
            throw AuthError.tokenFetchFailed
        }
    }
    
    private func addAuthorizationHeader(to request: URLRequest, with token: String) -> URLRequest {
        var newRequest = request
        newRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return newRequest
    }
    
    private func getBaseURL() async throws -> String {
        let param = try await db.getParam(by: .apiAdress)
        return param.value
    }
    
    private func getCredentials() async throws -> (username: String, password: String) {
        let userParam = try await db.getParam(by: .apiUser)
        let passwordParam = try await db.getParam(by: .apiPassword)
        return (username: userParam.value, password: passwordParam.value)
    }
}

struct TokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Date
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        
        let expiresInString = try container.decode(String.self, forKey: .expiresIn)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = dateFormatter.date(from: expiresInString) else {
            throw DecodingError.dataCorruptedError(forKey: .expiresIn, in: container, debugDescription: "Invalid date format")
        }
        expiresIn = date
    }
}

enum AuthError: Error {
    case invalidURL
    case tokenFetchFailed
}
