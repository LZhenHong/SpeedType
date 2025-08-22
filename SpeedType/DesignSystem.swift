//
//  DesignSystem.swift
//  SpeedType
//
//  Created by Assistant on 2024.
//

import SwiftUI

// MARK: - macOS Native Design System

extension Color {
  // macOS 语义化颜色 - 自动适配亮色/暗色模式
  static let primaryLabel = Color.primary
  static let secondaryLabel = Color.secondary
  static let tertiaryLabel = Color(NSColor.tertiaryLabelColor)
  static let quaternaryLabel = Color(NSColor.quaternaryLabelColor)

  // macOS 控件颜色
  static let controlAccent = Color.accentColor
  static let controlBackground = Color(NSColor.controlBackgroundColor)
  static let selectedControlColor = Color(NSColor.selectedControlColor)

  // macOS 背景颜色
  static let windowBackground = Color(NSColor.windowBackgroundColor)
  static let underPageBackground = Color(NSColor.underPageBackgroundColor)
  static let contentBackground = Color(NSColor.textBackgroundColor)

  // macOS 分隔符和边框
  static let separator = Color(NSColor.separatorColor)
  static let gridLine = Color(NSColor.gridColor)

  // 语义化状态颜色
  static let systemGreen = Color(NSColor.systemGreen)
  static let systemRed = Color(NSColor.systemRed)
  static let systemOrange = Color(NSColor.systemOrange)
  static let systemBlue = Color(NSColor.systemBlue)
  static let systemPurple = Color(NSColor.systemPurple)

  // 文本高亮和选择
  static let textHighlight = Color(NSColor.selectedTextBackgroundColor)
  static let keyboardFocusIndicator = Color(NSColor.keyboardFocusIndicatorColor)
}

// MARK: - macOS 排版系统

extension Font {
  // macOS 标准字体大小
  static let largeTitle = Font.largeTitle
  static let title = Font.title
  static let title2 = Font.title2
  static let title3 = Font.title3
  static let headline = Font.headline
  static let body = Font.body
  static let callout = Font.callout
  static let subheadline = Font.subheadline
  static let footnote = Font.footnote
  static let caption = Font.caption
  static let caption2 = Font.caption2

  // 等宽字体用于代码显示
  static let monospacedTitle = Font.title.monospaced()
  static let monospacedBody = Font.body.monospaced()
  static let monospacedCallout = Font.callout.monospaced()

  static let inputMonospaced: Font = .system(size: 20, weight: .medium).monospaced()
}

// MARK: - macOS 间距系统

enum MacSpacing {
  static let xxs: CGFloat = 2 // 极小间距
  static let xs: CGFloat = 4 // 小间距
  static let sm: CGFloat = 8 // 小间距
  static let md: CGFloat = 12 // 中等间距
  static let lg: CGFloat = 16 // 大间距
  static let xl: CGFloat = 20 // 特大间距
  static let xxl: CGFloat = 24 // 超大间距
  static let xxxl: CGFloat = 32 // 极大间距

  // macOS 标准内边距
  static let controlPadding: CGFloat = 8
  static let windowPadding: CGFloat = 20
  static let sectionPadding: CGFloat = 16
}

// MARK: - macOS 圆角系统

enum MacCornerRadius {
  static let small: CGFloat = 4 // 小控件
  static let medium: CGFloat = 6 // 按钮、文本框
  static let large: CGFloat = 8 // 面板、卡片
  static let window: CGFloat = 10 // 窗口圆角
}

// MARK: - macOS 阴影系统

extension View {
  func macOSShadow(_ level: MacShadowLevel = .medium) -> some View {
    switch level {
    case .subtle:
      return shadow(
        color: Color.black.opacity(0.1),
        radius: 1,
        x: 0,
        y: 0.5
      )

    case .medium:
      return shadow(
        color: Color.black.opacity(0.15),
        radius: 4,
        x: 0,
        y: 2
      )

    case .prominent:
      return shadow(
        color: Color.black.opacity(0.2),
        radius: 8,
        x: 0,
        y: 4
      )
    }
  }
}

enum MacShadowLevel {
  case subtle, medium, prominent
}

// MARK: - macOS 材质效果

extension View {
  func macOSMaterial(_ material: NSVisualEffectView.Material = .contentBackground) -> some View {
    background(VisualEffectView(material: material))
  }
}

struct VisualEffectView: NSViewRepresentable {
  let material: NSVisualEffectView.Material
  let blendingMode: NSVisualEffectView.BlendingMode

  init(material: NSVisualEffectView.Material, blendingMode: NSVisualEffectView.BlendingMode = .behindWindow) {
    self.material = material
    self.blendingMode = blendingMode
  }

  func makeNSView(context _: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.material = material
    view.blendingMode = blendingMode
    view.state = .active
    return view
  }

  func updateNSView(_ nsView: NSVisualEffectView, context _: Context) {
    nsView.material = material
    nsView.blendingMode = blendingMode
  }
}

// MARK: - macOS 焦点环

extension View {
  func macOSFocusRing() -> some View {
    background(
      RoundedRectangle(cornerRadius: MacCornerRadius.medium)
        .stroke(Color.keyboardFocusIndicator, lineWidth: 4)
        .opacity(0)
    )
  }
}
