//
//  ButtonStyles.swift
//  SpeedType
//
//  Created by Assistant on 2024.
//

import SwiftUI

// MARK: - Button Press Effect Modifier

private struct ButtonPressEffect: ViewModifier {
  let isPressed: Bool
  let scale: CGFloat
  let duration: Double

  func body(content: Content) -> some View {
    content
      .scaleEffect(isPressed ? scale : 1.0)
      .animation(.easeInOut(duration: duration), value: isPressed)
  }
}

private extension View {
  func pressEffect(_ isPressed: Bool, scale: CGFloat = 0.98, duration: Double = 0.1) -> some View {
    modifier(ButtonPressEffect(isPressed: isPressed, scale: scale, duration: duration))
  }
}

// MARK: - Button Background Styles

private struct ButtonBackground<S: ShapeStyle>: View {
  let isPressed: Bool
  let fill: S
  let pressedFill: S
  let strokeColor: Color?
  let strokeWidth: CGFloat

  var body: some View {
    RoundedRectangle(cornerRadius: MacCornerRadius.medium)
      .fill(isPressed ? pressedFill : fill)
      .overlay {
        if let strokeColor {
          RoundedRectangle(cornerRadius: MacCornerRadius.medium)
            .stroke(strokeColor, lineWidth: strokeWidth)
        }
      }
  }
}

// MARK: - macOS Native Button Styles

struct MacPrimaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

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
      .pressEffect(configuration.isPressed)
  }

  private func buttonColor(isPressed: Bool) -> Color {
    if !isEnabled { return Color.controlBackground }
    return isPressed ? Color.controlAccent.opacity(0.8) : Color.controlAccent
  }
}

struct MacSecondaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundStyle(isEnabled ? Color.primaryLabel : Color.quaternaryLabel)
      .padding(.horizontal, MacSpacing.lg)
      .padding(.vertical, MacSpacing.controlPadding)
      .background(
        ButtonBackground(
          isPressed: configuration.isPressed,
          fill: Color.controlBackground,
          pressedFill: Color.selectedControlColor,
          strokeColor: .separator,
          strokeWidth: 0.5
        )
      )
      .pressEffect(configuration.isPressed)
  }
}

struct MacDestructiveButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundStyle(isEnabled ? Color.systemRed : Color.quaternaryLabel)
      .padding(.horizontal, MacSpacing.lg)
      .padding(.vertical, MacSpacing.controlPadding)
      .background(
        ButtonBackground(
          isPressed: configuration.isPressed,
          fill: Color.controlBackground,
          pressedFill: Color.systemRed.opacity(0.1),
          strokeColor: isEnabled ? Color.systemRed.opacity(0.3) : .separator,
          strokeWidth: 1
        )
      )
      .pressEffect(configuration.isPressed)
  }
}

// MARK: - Borderless Button

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
      .pressEffect(configuration.isPressed, scale: 0.95, duration: 0.08)
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
