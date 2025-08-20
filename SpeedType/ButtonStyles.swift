//
//  ButtonStyles.swift
//  SpeedType
//
//  Created by Assistant on 2024.
//

import SwiftUI

/// 统一的按钮样式扩展
extension Button {
  /// 主要操作按钮样式 - 突出显示
  func primaryButtonStyle() -> some View {
    buttonStyle(.borderedProminent)
      .controlSize(.large)
  }

  /// 次要操作按钮样式 - 边框样式
  func secondaryButtonStyle() -> some View {
    buttonStyle(.bordered)
      .controlSize(.large)
  }

  /// 危险操作按钮样式 - 红色边框
  func dangerButtonStyle() -> some View {
    buttonStyle(.bordered)
      .controlSize(.large)
      .foregroundStyle(.red)
  }
}
