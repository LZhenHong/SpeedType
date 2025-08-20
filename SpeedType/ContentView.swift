//
//  ContentView.swift
//  SpeedType
//
//  Created by Eden on 2024/12/19.
//

import Foundation
import SwiftUI

struct ContentView: View {
  // MARK: - Properties

  @State private var testState = TypingTestState()
  @FocusState private var isInputFocused: Bool
  @State private var showResultView = false

  // MARK: - Body

  var body: some View {
    ZStack {
      // macOS 原生背景
      Color(NSColor.windowBackgroundColor)
        .ignoresSafeArea()

      VStack(spacing: 32) {
        // 标题 - 使用 macOS 大标题样式
        Text("SpeedType")
          .font(.system(size: 34, weight: .bold, design: .default))
          .foregroundStyle(.primary)

        // 配置面板（仅在未开始时显示）
        if !testState.isTyping {
          configurationPanel
        }

        Spacer()

        // 文本显示和输入区域
        VStack(spacing: 20) {
          // 文本显示
          textDisplayView

          // 隐藏的文本输入框
          TextField("", text: $testState.userInput)
            .opacity(0)
            .frame(height: 0)
            .focused($isInputFocused)
            .onChange(of: testState.userInput) { _, newValue in
              TypingEngine.handleInput(newValue, state: testState)
            }
            .onChange(of: testState.isFinished) { _, isFinished in
              if isFinished {
                showResultView = true
                isInputFocused = false
              }
            }
            .disabled(testState.isFinished)
        }

        Spacer()

        // 统计信息
        statisticsView

        // 控制按钮
        if testState.isFinished {
          HStack(spacing: 16) {
            Button("重新开始") {
              testState.resetTest()
              isInputFocused = true
            }
            .primaryButtonStyle()
            .keyboardShortcut(.defaultAction)

            Button("查看结果") {
              showResultView = true
            }
            .secondaryButtonStyle()
          }
        } else if testState.isTyping {
          Button("结束测试") {
            testState.finishTest()
            showResultView = true
          }
          .dangerButtonStyle()
          .keyboardShortcut(.escape)
        } else {
          Button("开始测试") {
            testState.startTest()
            isInputFocused = true
          }
          .primaryButtonStyle()
          .keyboardShortcut(.defaultAction)
        }
      }
      .padding(.horizontal, 48)
      .padding(.vertical, 32)
    }
    .frame(minWidth: 900, minHeight: 650)
    .onChange(of: testState.selectedChallenge) { _, newValue in
      // 只在非完成状态时才重置测试，避免破坏结果显示
      if !testState.isFinished {
        testState.changeChallenge(newValue)
      }
    }
    .onAppear {
      isInputFocused = true
    }

    .sheet(isPresented: $showResultView) {
      ResultView(
        testState: testState,
        onRestart: {
          showResultView = false
          testState.resetTest()
          isInputFocused = true
        },
        onShare: {
          shareResult()
        }
      )
    }
  }

  // MARK: - Private Views

  private var textDisplayView: some View {
    Text(TypingEngine.generateAttributedText(for: testState))
      .font(.system(size: 20, weight: .medium, design: .monospaced))
      .lineSpacing(10)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 32)
      .padding(.vertical, 24)
      .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 16))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.primary.opacity(0.08), lineWidth: 1)
      )
      .offset(x: testState.shouldShake ? 15 : 0)
      .animation(
        testState.shouldShake
          ? Animation.easeInOut(duration: 0.06).repeatCount(8, autoreverses: true)
          : .default,
        value: testState.shouldShake
      )
  }

  private var configurationPanel: some View {
    VStack(spacing: 20) {
      // 挑战选择区域
      HStack {
        Text("选择挑战:")
          .font(.system(size: 16, weight: .semibold))
          .foregroundStyle(.primary)

        Picker("", selection: $testState.selectedChallenge) {
          ForEach(Challenge.predefinedChallenges, id: \.id) { challenge in
            Text(challenge.title).tag(challenge)
          }
        }
        .pickerStyle(.menu)
        .controlSize(.regular)
        .fixedSize()
        .disabled(testState.isFinished)

        Spacer()
      }

      // 设置选项区域
      HStack(spacing: 32) {
        HStack(spacing: 12) {
          Image(systemName: "textformat.abc")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.secondary)
            .frame(width: 16)

          Toggle("大小写敏感", isOn: $testState.isCaseSensitive)
            .toggleStyle(.switch)
            .controlSize(.regular)
        }

        HStack(spacing: 12) {
          Image(systemName: "exclamationmark.triangle")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.secondary)
            .frame(width: 16)

          Toggle("严格模式", isOn: $testState.isStrictMode)
            .toggleStyle(.switch)
            .controlSize(.regular)
        }

        Spacer()
      }
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 20)
    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
    )
  }

  // MARK: - Statistics View

  private var statisticsView: some View {
    HStack(spacing: 48) {
      StatisticItem(icon: "speedometer", value: String(format: "%.1f", testState.wpm), label: "WPM")
      StatisticItem(icon: "checkmark.circle", value: "\(testState.accuracy)%", label: "准确率")
      StatisticItem(icon: "textformat.123", value: "\(testState.currentIndex)", label: "字符")
      StatisticItem(
        icon: "clock", value: String(format: "%05.2fs", testState.elapsedTime), label: "时间"
      )
    }
    .padding(.horizontal, 32)
    .padding(.vertical, 20)
    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
    )
  }
}

extension ContentView {

  private func shareResult() {
    let wpm = Int(testState.wpm.rounded())
    let accuracy = testState.accuracy
    let timeText = String(format: "%.1f", testState.elapsedTime)

    let shareText = """
      🎯 SpeedType 测试结果

      ⚡ 速度: \(wpm) WPM
      🎯 准确率: \(String(format: "%.1f", accuracy))%
      ⏱️ 用时: \(timeText)秒
      📝 字符数: \(testState.correctChars)

      #SpeedType #打字练习
      """

    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(shareText, forType: .string)
  }
}

#Preview {
  ContentView()
}
