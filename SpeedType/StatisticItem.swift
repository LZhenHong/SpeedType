//
//  StatisticItem.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import SwiftUI

struct StatisticItem: View {
  let icon: String
  let value: String
  let label: String

  var body: some View {
    VStack(spacing: 4) {
      Image(systemName: icon)
        .foregroundColor(.white)
      Text(value)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
      Text(label)
        .font(.caption)
        .foregroundColor(.gray)
    }
  }
}
