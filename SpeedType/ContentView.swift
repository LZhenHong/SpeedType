//
//  ContentView.swift
//  SpeedType
//
//  Created by Eden on 2024/12/19.
//

import Foundation
import QuartzCore
import SwiftUI

struct ContentView: View {
  // MARK: - Properties

  @State private var testState = TypingTestState()
  @FocusState private var isInputFocused: Bool
  @State private var showResultView = false
  @State private var frameTimer: Timer?
  @State private var refreshTrigger = 0

  // MARK: - Body

  var body: some View {
    ZStack {
      // macOS 原生背景
      Color.windowBackground
        .ignoresSafeArea()

      VStack(spacing: MacSpacing.xxxl) {
        // 标题区域 - macOS 风格
        VStack(spacing: MacSpacing.sm) {
          Text("SpeedType")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(Color.primaryLabel)

          Text("测试你的打字速度")
            .font(.title3)
            .foregroundStyle(Color.secondaryLabel)
        }
        .padding(.top, MacSpacing.windowPadding)

        // 配置面板（仅在未开始时显示）
        if !testState.isTyping {
          configurationPanel
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }

        Spacer()

        // 文本显示和输入区域
        VStack(spacing: MacSpacing.lg) {
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

        // 控制按钮区域
        VStack(spacing: MacSpacing.md) {
          if testState.isFinished {
            HStack(spacing: MacSpacing.lg) {
              Button("重新开始") {
                testState.resetTest()
                isInputFocused = true
              }
              .macPrimaryStyle()
              .keyboardShortcut(.defaultAction)

              Button("查看结果") {
                showResultView = true
              }
              .macSecondaryStyle()
            }
          } else if testState.isTyping {
            Button("结束测试") {
              testState.resetTest()
              isInputFocused = true
            }
            .macDestructiveStyle()
            .keyboardShortcut(.escape)
          } else {
            Button("开始测试") {
              testState.startTest()
              isInputFocused = true
            }
            .macPrimaryStyle()
            .keyboardShortcut(.defaultAction)
          }

          // 键盘快捷键提示
          Group {
            if !testState.isTyping {
              Text("按 Return 开始测试")
            } else {
              Text("按 Escape 结束测试")
            }
          }
          .font(.caption)
          .foregroundStyle(Color.tertiaryLabel)
        }
        .padding(.bottom, MacSpacing.windowPadding)
      }
      .padding(.horizontal, MacSpacing.windowPadding)
    }
    .frame(minWidth: 800, minHeight: 600)
    .animation(.easeInOut(duration: 0.3), value: testState.isTyping)
    .onChange(of: testState.selectedChallenge) { _, newValue in
      if !testState.isFinished {
        testState.changeChallenge(newValue)
      }
    }
    .onChange(of: testState.isTyping) { _, isTyping in
      if isTyping {
        startFrameTimer()
      } else {
        stopFrameTimer()
      }
    }
    .onAppear {
      isInputFocused = true
    }
    .onDisappear {
      stopFrameTimer()
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
      .font(.inputMonospaced)
      .lineSpacing(10)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, MacSpacing.xxl)
      .padding(.horizontal, MacSpacing.xxxl)
      .background(
        RoundedRectangle(cornerRadius: MacCornerRadius.large)
          .fill(Color.contentBackground)
          .overlay(
            RoundedRectangle(cornerRadius: MacCornerRadius.large)
              .stroke(Color.separator, lineWidth: 1)
          )
      )
      .macOSShadow(.subtle)
      .offset(x: testState.shouldShake ? 8 : 0)
      .animation(
        testState.shouldShake
          ? Animation.easeInOut(duration: 0.06).repeatCount(6, autoreverses: true)
          : .default,
        value: testState.shouldShake
      )
  }

  private var configurationPanel: some View {
    HStack(spacing: MacSpacing.lg) {
      // 挑战选择区域
      HStack(spacing: MacSpacing.md) {
        Picker("选择挑战：", selection: $testState.selectedChallenge) {
          ForEach(Challenge.predefinedChallenges, id: \.id) { challenge in
            Text(challenge.title).tag(challenge)
          }
        }
        .pickerStyle(.menu)
        .controlSize(.regular)
        .fixedSize()
        .disabled(testState.isFinished)
      }

      Spacer()

      // 设置选项区域
      HStack(spacing: MacSpacing.xxxl) {
        MacToggleOption(
          icon: "textformat.abc",
          title: "大小写敏感",
          isOn: $testState.isCaseSensitive
        )

        MacToggleOption(
          icon: "exclamationmark.triangle",
          title: "严格模式",
          isOn: $testState.isStrictMode
        )
      }
    }
    .padding(MacSpacing.sectionPadding)
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

  // MARK: - Statistics View

  private var statisticsView: some View {
    HStack(spacing: MacSpacing.xxxl) {
      MacStatisticItem(icon: "speedometer", iconColor: .systemBlue, value: String(format: "%.1f", testState.wpm), label: "WPM")
      MacStatisticItem(icon: "checkmark.circle", iconColor: .systemGreen, value: "\(testState.accuracy)%", label: "准确率")
      MacStatisticItem(icon: "textformat.123", iconColor: Color.systemPurple, value: "\(testState.currentIndex)", label: "字符")
      MacStatisticItem(icon: "clock", iconColor: Color.systemOrange, value: String(format: "%.3fs", testState.elapsedTime), label: "时间")
    }
    .id(refreshTrigger) // 强制刷新时间显示
    .padding(MacSpacing.sectionPadding)
    .background(
      RoundedRectangle(cornerRadius: MacCornerRadius.large)
        .fill(Color.contentBackground)
        .overlay(
          RoundedRectangle(cornerRadius: MacCornerRadius.large)
            .stroke(Color.separator, lineWidth: 1)
        )
    )
    .macOSShadow(.subtle)
    .frame(width: 450)
  }
}

// MARK: - macOS Style Components

struct MacToggleOption: View {
  let icon: String
  let title: String
  @Binding var isOn: Bool

  var body: some View {
    HStack(spacing: MacSpacing.md) {
      Image(systemName: icon)
        .font(.body)
        .foregroundStyle(Color.controlAccent)
        .frame(width: 16, height: 16)

      Text(title)
        .font(.body)
        .foregroundStyle(Color.primaryLabel)

      Toggle("", isOn: $isOn)
        .toggleStyle(.switch)
        .controlSize(.small)
    }
  }
}

extension ContentView {
  // MARK: - Frame Timer Management

  private func startFrameTimer() {
    stopFrameTimer() // 确保没有重复的定时器

    // 60fps 刷新率，与大多数显示器的刷新率匹配
    frameTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
      refreshTimerDisplay()
    }

    // 将 Timer 添加到 common run loop 模式以确保在滚动等操作时也能正常工作
    if let frameTimer {
      RunLoop.current.add(frameTimer, forMode: .common)
    }
  }

  private func stopFrameTimer() {
    frameTimer?.invalidate()
    frameTimer = nil
  }

  private func refreshTimerDisplay() {
    if testState.isTyping {
      // 通过修改 refreshTrigger 来强制界面刷新
      refreshTrigger += 1
    }
  }

  // MARK: - Share Functionality

  private func shareResult() {
    if let image = ImageShareHelper.generateResultImage(testState: testState) {
      ImageShareHelper.shareImage(image)

      // 显示成功提示
      DispatchQueue.main.async {
        let alert = NSAlert()
        alert.messageText = "分享成功"
        alert.informativeText = "测试结果图片已保存并可分享"
        alert.addButton(withTitle: "确定")
        alert.runModal()
      }
    } else {
      // 备用方案：文本分享
      let wpm = Int(testState.wpm.rounded())
      let accuracy = testState.accuracy
      let timeText = String(format: "%.3f", testState.elapsedTime)

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

      // 显示备用方案提示
      DispatchQueue.main.async {
        let alert = NSAlert()
        alert.messageText = "分享成功"
        alert.informativeText = "测试结果文本已复制到剪贴板"
        alert.addButton(withTitle: "确定")
        alert.runModal()
      }
    }
  }
}

#Preview {
  ContentView()
}
