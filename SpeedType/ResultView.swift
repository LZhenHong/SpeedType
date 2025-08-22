//
//  ResultView.swift
//  SpeedType
//
//  Created by Assistant on 2024.
//

import SwiftUI

struct ResultView: View {
  let testState: TypingTestState
  let onRestart: () -> Void
  let onShare: () -> Void

  var body: some View {
    ZStack {
      // macOS 原生背景
      Color.windowBackground
        .ignoresSafeArea()

      VStack(spacing: MacSpacing.xl) {
        Spacer(minLength: MacSpacing.lg)

        // 标题区域 - macOS 风格
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

        // 结果展示区域 - macOS 卡片布局
        VStack(spacing: MacSpacing.lg) {
          // 主要指标卡片
          HStack(spacing: MacSpacing.lg) {
            MacResultCard(
              icon: "speedometer",
              iconColor: Color.systemBlue,
              value: String(format: "%.1f", testState.wpm),
              label: "WPM",
              subtitle: "每分钟字数"
            )

            MacResultCard(
              icon: "target",
              iconColor: Color.systemGreen,
              value: "\(testState.accuracy)%",
              label: "准确率",
              subtitle: "正确率"
            )
          }

          // 次要指标卡片
          HStack(spacing: MacSpacing.lg) {
            MacResultCard(
              icon: "textformat.123",
              iconColor: Color.systemPurple,
              value: "\(testState.currentIndex)",
              label: "字符",
              subtitle: "总字符数"
            )

            MacResultCard(
              icon: "clock",
              iconColor: Color.systemOrange,
              value: String(format: "%.3f", testState.elapsedTime),
              label: "时间",
              subtitle: "秒"
            )
          }
        }

        Spacer(minLength: MacSpacing.lg)

        // 操作按钮区域
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

        Spacer(minLength: MacSpacing.lg)
      }
      .padding(.horizontal, MacSpacing.xl)
      .padding(.vertical, MacSpacing.lg)
    }
    .frame(minWidth: 420, minHeight: 520)
  }
}

// MARK: - macOS Result Card Component

struct MacResultCard: View {
  let icon: String
  let iconColor: Color
  let value: String
  let label: String
  let subtitle: String

  var body: some View {
    VStack(spacing: MacSpacing.md) {
      // 图标区域
      Image(systemName: icon)
        .font(.title)
        .foregroundStyle(iconColor)
        .symbolRenderingMode(.hierarchical)
        .frame(height: 28)

      // 数值区域
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
    .background(
      RoundedRectangle(cornerRadius: MacCornerRadius.large)
        .fill(Color.contentBackground)
        .overlay(
          RoundedRectangle(cornerRadius: MacCornerRadius.large)
            .stroke(Color.separator, lineWidth: 1)
        )
    )
    .macOSShadow(.subtle)
  }
}

#Preview {
  @Previewable @State var sampleState: TypingTestState = {
    let state = TypingTestState()
    state.correctChars = 250
    state.errorCount = 10
    // 模拟完成的测试：设置开始和结束时间
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
