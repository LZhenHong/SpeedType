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
    VStack(spacing: 6) {
      Image(systemName: icon)
        .font(.system(size: 18, weight: .medium))
        .foregroundStyle(.secondary)
        .symbolRenderingMode(.hierarchical)

      Text(value)
        .font(.system(.title2, design: .monospaced, weight: .semibold))
        .foregroundStyle(.primary)
        .frame(minWidth: 80, alignment: .center)

      Text(label)
        .font(.caption)
        .foregroundStyle(.tertiary)
        .textCase(.uppercase)
        .tracking(0.5)
    }
  }
}
