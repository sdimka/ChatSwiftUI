//
//  AppDelegate+Injection.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 22.02.2024.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerAppServices()
        registerView()
    }
}
