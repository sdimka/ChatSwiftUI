//
//  MainViewModel.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation

@Observable
class MainViewModel {
    
    var isSearchEnabled = false
    
    func performSearch() {
        print("Some text")
        isSearchEnabled = !isSearchEnabled
    }

}
