//
//  Color.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 14.02.2024.
//

import Foundation
import SwiftUI

struct ShapeStyleExample: ShapeStyle {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        if environment.colorScheme == .light {
            return Color.chBack
        } else {
            return Color.yellow
        }
    }
}

extension ShapeStyle where Self == ShapeStyleExample {
    static var shapeStyleExample: Self {
        ShapeStyleExample()
    }
}
