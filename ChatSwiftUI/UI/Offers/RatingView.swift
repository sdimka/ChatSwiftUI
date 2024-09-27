//
//  RatingView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 27.09.2024.
//

import Foundation
import SwiftUI

struct RatingView: View {
  /// A value in range of 0.0 to 5.0.
 @State var value: Double
    
  var body: some View {
    HStack(spacing: 0) {
      ForEach(0..<5) { index in
        Image(systemName: imageName(for: index, value: value))
      }
    }
    .foregroundColor(.yellow)
  }
  
  func imageName(for starIndex: Int, value: Double) -> String {
    if value >= Double(starIndex + 1) {
        return "star.fill"
    }
    else if value >= Double(starIndex) + 0.5 {
        return "star.leadinghalf.filled"
    }
    else {
        return "star"
    }
  }
}
