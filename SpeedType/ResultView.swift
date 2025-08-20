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
      // 统一的macOS背景
      Color(NSColor.windowBackgroundColor)
        .ignoresSafeArea()

      VStack(spacing: 24) {
        Spacer(minLength: 20)

        // 标题区域 - macOS原生样式
        VStack(spacing: 12) {
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 48, weight: .medium))
            .foregroundStyle(.green)

          Text("测试完成")
            .font(.system(size: 28, weight: .bold, design: .default))
            .foregroundStyle(.primary)
        }

        // 结果展示区域 - 统一设计风格
        VStack(spacing: 24) {
          // 主要指标
          HStack(spacing: 32) {
            StatisticItem(
              icon: "speedometer",
              value: String(format: "%.1f", testState.wpm),
              label: "WPM"
            )

            StatisticItem(
              icon: "target",
              value: "\(testState.accuracy)%",
              label: "准确率"
            )
          }

          // 次要指标
          HStack(spacing: 32) {
            StatisticItem(
              icon: "textformat.123",
              value: "\(testState.currentIndex)",
              label: "字符"
            )

            StatisticItem(
              icon: "clock",
              value: String(format: "%.2f", testState.elapsedTime),
              label: "时间"
            )
          }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
        )

        Spacer(minLength: 20)

        // 操作按钮 - 统一样式
        HStack(spacing: 12) {
          Button("重新开始", action: onRestart)
            .primaryButtonStyle()

          Button("分享结果", action: onShare)
            .secondaryButtonStyle()
        }

        Spacer(minLength: 20)
      }
      .padding(.horizontal, 32)
      .padding(.vertical, 24)
      .frame(minWidth: 500, minHeight: 400)
    }
  }
}

#Preview {
  @Previewable @State var sampleState: TypingTestState = {
    let state = TypingTestState()
    state.correctChars = 250
    state.errorCount = 10
    state.elapsedTime = 60.0
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
