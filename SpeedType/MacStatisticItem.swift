//
//  MacStatisticItem.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import SwiftUI

struct MacStatisticItem: View {
  let icon: String
  let iconColor: Color
  let value: String
  let label: String

  var body: some View {
    VStack(spacing: MacSpacing.xs) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundStyle(iconColor)
        .symbolRenderingMode(.hierarchical)

      Text(value)
        .font(.title2.monospaced())
        .fontWeight(.semibold)
        .foregroundStyle(Color.primaryLabel)

      Text(label)
        .font(.caption)
        .foregroundStyle(Color.tertiaryLabel)
        .textCase(.uppercase)
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  MacStatisticItem(icon: "speedometer", iconColor: .purple, value: String(format: "%.1f", 10.1), label: "WPM")
}
