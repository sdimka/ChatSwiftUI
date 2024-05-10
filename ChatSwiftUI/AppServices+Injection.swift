//
//  AppServices+Injection.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 22.02.2024.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerAppServices() {
        register{ DBService() }.scope(.application)
        register{ AIService() }.scope(.application)
//        register{ AsyncDataService() }.scope(.application)
        
    }
    
    public static func registerView() {
        register{ MainView() }.scope(.application)
        register{ SecondColumnView() }.scope(.application)
        register{ SettingsView() }.scope(.application)
        register{ TestView() }.scope(.application)
    }
    
    public static func registerViewModels() {
        register{ MainViewModel() }.scope(.application)
//        register{ SecondColumnView() }.scope(.application)
//        register{ SettingsView() }.scope(.application)
//        register{ TestView() }.scope(.application)
    }
}
