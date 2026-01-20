//
//  ResultView.swift
//  SpeedType
//
//  Created by Assistant on 2024.
//

import SwiftUI

// MARK: - Result Card Data

private struct ResultCardData: Identifiable {
  let id = UUID()
  let icon: String
  let iconColor: Color
  let value: String
  let label: String
  let subtitle: String
}

// MARK: - Result View

struct ResultView: View {
  let testState: TypingTestState
  let onRestart: () -> Void
  let onShare: () -> Void

  private var primaryCards: [ResultCardData] {
    [
      ResultCardData(
        icon: "speedometer", iconColor: .systemBlue,
        value: String(format: "%.1f", testState.wpm),
        label: "WPM", subtitle: "每分钟字数"
      ),
      ResultCardData(
        icon: "target", iconColor: .systemGreen,
        value: "\(testState.accuracy)%",
        label: "准确率", subtitle: "正确率"
      ),
    ]
  }

  private var secondaryCards: [ResultCardData] {
    [
      ResultCardData(
        icon: "textformat.123", iconColor: .systemPurple,
        value: "\(testState.currentIndex)",
        label: "字符", subtitle: "总字符数"
      ),
      ResultCardData(
        icon: "clock", iconColor: .systemOrange,
        value: String(format: "%.3f", testState.elapsedTime),
        label: "时间", subtitle: "秒"
      ),
    ]
  }

  var body: some View {
    ZStack {
      Color.windowBackground.ignoresSafeArea()

      VStack(spacing: MacSpacing.xl) {
        Spacer(minLength: MacSpacing.lg)
        headerSection
        cardsSection
        Spacer(minLength: MacSpacing.lg)
        actionSection
        Spacer(minLength: MacSpacing.lg)
      }
      .padding(.horizontal, MacSpacing.xl)
      .padding(.vertical, MacSpacing.lg)
    }
    .frame(minWidth: 420, minHeight: 520)
  }

  // MARK: - View Sections

  private var headerSection: some View {
    VStack(spacing: MacSpacing.lg) {
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 48, weight: .medium))
        .foregroundStyle(Color.systemGreen)
        .symbolRenderingMode(.hierarchical)

      VStack(spacing: MacSpacing.xs) {
        Text("测试完成")
          .font(.title)
          .fontWeight(.semibold)
          .foregroundStyle(Color.primaryLabel)

        Text("恭喜你完成了打字测试！")
          .font(.body)
          .foregroundStyle(Color.secondaryLabel)
      }
    }
  }

  private var cardsSection: some View {
    VStack(spacing: MacSpacing.lg) {
      HStack(spacing: MacSpacing.lg) {
        ForEach(primaryCards) { card in
          MacResultCard(
            icon: card.icon,
            iconColor: card.iconColor,
            value: card.value,
            label: card.label,
            subtitle: card.subtitle
          )
        }
      }
      HStack(spacing: MacSpacing.lg) {
        ForEach(secondaryCards) { card in
          MacResultCard(
            icon: card.icon,
            iconColor: card.iconColor,
            value: card.value,
            label: card.label,
            subtitle: card.subtitle
          )
        }
      }
    }
  }

  private var actionSection: some View {
    VStack(spacing: MacSpacing.sm) {
      HStack(spacing: MacSpacing.lg) {
        Button("重新开始", action: onRestart)
          .macPrimaryStyle()
          .keyboardShortcut(.defaultAction)

        Button("分享结果", action: onShare)
          .macSecondaryStyle()
      }

      Text("按 Return 重新开始测试")
        .font(.caption)
        .foregroundStyle(Color.tertiaryLabel)
    }
  }
}

// MARK: - macOS Result Card Component

private struct MacResultCard: View {
  let icon: String
  let iconColor: Color
  let value: String
  let label: String
  let subtitle: String

  var body: some View {
    VStack(spacing: MacSpacing.md) {
      Image(systemName: icon)
        .font(.title)
        .foregroundStyle(iconColor)
        .symbolRenderingMode(.hierarchical)
        .frame(height: 28)

      VStack(spacing: MacSpacing.xs) {
        Text(value)
          .font(.title.monospaced())
          .fontWeight(.bold)
          .foregroundStyle(Color.primaryLabel)

        Text(label)
          .font(.headline)
          .foregroundStyle(Color.secondaryLabel)

        Text(subtitle)
          .font(.caption)
          .foregroundStyle(Color.tertiaryLabel)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, MacSpacing.lg)
    .padding(.horizontal, MacSpacing.md)
    .background {
      RoundedRectangle(cornerRadius: MacCornerRadius.large)
        .fill(Color.contentBackground)
        .overlay(
          RoundedRectangle(cornerRadius: MacCornerRadius.large)
            .stroke(Color.separator, lineWidth: 1)
        )
    }
    .macOSShadow(.subtle)
  }
}

#Preview {
  @Previewable @State var sampleState: TypingTestState = {
    let state = TypingTestState()
    state.correctChars = 250
    state.errorCount = 10
    let currentTime = CACurrentMediaTime()
    state.setMockTimeForPreview(startTime: currentTime - 60.0, endTime: currentTime)
    state.currentIndex = 260
    state.isFinished = true
    return state
  }()

  ResultView(
    testState: sampleState,
    onRestart: {},
    onShare: {}
  )
}
