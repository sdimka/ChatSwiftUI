//
//  SettingsViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 17.02.2024.
//

import Foundation
import Resolver

@Observable
class SettingsViewModel {
    
    var apiKey: String = ""
    var apiModel: String = ""
    var dbPath: String = ""

    var apiAdress: String = ""
    var apiUser: String = ""
    var apiPassword: String = ""
    
    @ObservationIgnored
    @Injected private var db: DBService

    private var params: [ParamType: Param] = [:]
    
    init() {
        dbPath = db.getDBPath()
    }
    
    func update() {
        db.getAllParams { [weak self] result in
            switch result {
            case .success(let fetchedParams):
                self?.handleFetchedParams(fetchedParams)
            case .failure(let error):
                print("Error fetching params: \(error)")
            }
        }
    }

    private func handleFetchedParams(_ fetchedParams: [Param]) {
        for param in fetchedParams {
            params[param.type] = param
            switch param.type {
            case .aiKey:
                apiKey = param.value
            case .aiModel:
                apiModel = param.value
            case .apiAdress:
                apiAdress = param.value
            case .apiUser:
                apiUser = param.value
            case .apiPassword:
                apiPassword = param.value
            case .undef:
                print("Undefined param: \(param)")
            }
        }
    }

    func save() {
        saveParam(.aiKey, value: apiKey)
        saveParam(.aiModel, value: apiModel)
        saveParam(.apiAdress, value: apiAdress)
        saveParam(.apiUser, value: apiUser)
        saveParam(.apiPassword, value: apiPassword)
    }

    private func saveParam(_ type: ParamType, value: String) {
        if params[type] == nil {
            params[type] = Param(id: type.rawValue, type: type, value: value)
        }
        params[type]?.value = value
        db.setParams(param: params[type]!) { result in
            if case .failure(let error) = result {
                print("Error saving \(type): \(error)")
            }
        }
    }
    

//    func save() {
//        if apiKeyParam == nil {
//            apiKeyParam = Param(id: 1, type: .aiKey, value: apiKey)
//        }
//        if apiModelParam == nil {
//            apiModelParam = Param(id: 2, type: .aiModel, value: apiModel)
//        }
//        apiKeyParam?.value = apiKey
//        db.setParams(param: apiKeyParam!){ _ in }
//        
//        apiModelParam?.value = apiModel
//        db.setParams(param: apiModelParam!){ _ in }
//    }
    
}
