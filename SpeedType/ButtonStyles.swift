//
//  ButtonStyles.swift
//  SpeedType
//
//  Created by Assistant on 2024.
//

import SwiftUI

// MARK: - macOS Native Button Styles

struct MacPrimaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.colorScheme) private var colorScheme

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundStyle(.white)
      .padding(.horizontal, MacSpacing.lg)
      .padding(.vertical, MacSpacing.controlPadding)
      .background(
        RoundedRectangle(cornerRadius: MacCornerRadius.medium)
          .fill(buttonColor(isPressed: configuration.isPressed))
      )
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
  }

  private func buttonColor(isPressed: Bool) -> Color {
    if !isEnabled {
      return Color.controlBackground
    }

    if isPressed {
      return Color.controlAccent.opacity(0.8)
    }

    return Color.controlAccent
  }
}

struct MacSecondaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.colorScheme) private var colorScheme

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundStyle(isEnabled ? Color.primaryLabel : Color.quaternaryLabel)
      .padding(.horizontal, MacSpacing.lg)
      .padding(.vertical, MacSpacing.controlPadding)
      .background(
        RoundedRectangle(cornerRadius: MacCornerRadius.medium)
          .fill(configuration.isPressed ? Color.selectedControlColor : Color.controlBackground)
          .overlay(
            RoundedRectangle(cornerRadius: MacCornerRadius.medium)
              .stroke(Color.separator, lineWidth: 0.5)
          )
      )
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
  }
}

struct MacDestructiveButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.colorScheme) private var colorScheme

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundStyle(isEnabled ? Color.systemRed : Color.quaternaryLabel)
      .padding(.horizontal, MacSpacing.lg)
      .padding(.vertical, MacSpacing.controlPadding)
      .background(
        RoundedRectangle(cornerRadius: MacCornerRadius.medium)
          .fill(configuration.isPressed ? Color.systemRed.opacity(0.1) : Color.controlBackground)
          .overlay(
            RoundedRectangle(cornerRadius: MacCornerRadius.medium)
              .stroke(isEnabled ? Color.systemRed.opacity(0.3) : Color.separator, lineWidth: 1)
          )
      )
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
  }
}

// MARK: - Borderless Button (用于工具栏等场景)

struct MacBorderlessButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.body)
      .foregroundStyle(isEnabled ? Color.controlAccent : Color.quaternaryLabel)
      .padding(.horizontal, MacSpacing.sm)
      .padding(.vertical, MacSpacing.xs)
      .background(
        RoundedRectangle(cornerRadius: MacCornerRadius.small)
          .fill(configuration.isPressed ? Color.selectedControlColor : Color.clear)
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
  }
}

// MARK: - Button Style Extensions

extension Button {
  func macPrimaryStyle() -> some View {
    buttonStyle(MacPrimaryButtonStyle())
  }

  func macSecondaryStyle() -> some View {
    buttonStyle(MacSecondaryButtonStyle())
  }

  func macDestructiveStyle() -> some View {
    buttonStyle(MacDestructiveButtonStyle())
  }

  func macBorderlessStyle() -> some View {
    buttonStyle(MacBorderlessButtonStyle())
  }
}
