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
    
    @ObservationIgnored
    @Injected private var db: DBService

    private var apiKeyParam: Param? = nil
    private var apiModelParam: Param? = nil
    
    init() {
//        let paprams =

    }
    
    func update(){
        db.getParams{ [weak self] result in
            switch result {
            case .success(let params):
                params.forEach { param in
                    switch param.type {
                    case .aiKey:
                        self?.apiKey = param.value
                        self?.apiKeyParam = param
                    case .aiModel:
                        self?.apiModel = param.value
                        self?.apiModelParam = param
                    case .undef:
                        print("Undefined param")
                    }
                }
                
            case .failure(let error):
                print("Error \(error)")
            }

            
        }
    }
    
    func save() {
        if apiKeyParam == nil {
            apiKeyParam = Param(id: 1, type: .aiKey, value: apiKey)
        }
        if apiModelParam == nil {
            apiModelParam = Param(id: 2, type: .aiModel, value: apiModel)
        }
        apiKeyParam?.value = apiKey
        db.setParams(param: apiKeyParam!){ _ in }
        
        apiModelParam?.value = apiModel
        db.setParams(param: apiModelParam!){ _ in }
    }
    
}
