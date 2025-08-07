//
//  ContentView.swift
//  SpeedType
//
//  Created by Eden on 2024/12/19.
//

import Foundation
import SwiftUI

struct ContentView: View {
  // MARK: - State Properties
  @State private var selectedChallenge = Challenge.predefinedChallenges[0]
  @State private var userInput = ""
  @State private var isTyping = false
  @State private var isFinished = false
  @State private var startTime: Date?
  @State private var elapsedTime: TimeInterval = 0
  @State private var timerPublisher = Timer.publish(every: 0.01, on: .main, in: .common)
    .autoconnect()
  @State private var currentIndex = 0
  @State private var errorCount = 0
  @State private var correctChars = 0

  // MARK: - Computed Properties
  private var wpm: Double {
    guard elapsedTime > 0 else { return 0 }
    let minutes = elapsedTime / 60.0
    let words = Double(correctChars) / 5.0  // 标准：5个字符 = 1个单词
    return words / minutes
  }

  private var accuracy: Int {
    let totalTyped = correctChars + errorCount
    guard totalTyped > 0 else { return 100 }
    return Int((Double(correctChars) / Double(totalTyped)) * 100)
  }

  // MARK: - Body
  var body: some View {
    ZStack {
      // 背景
      Color.black
        .ignoresSafeArea()

      VStack(spacing: 30) {
        // 标题
        Text("SpeedType")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)

        // 挑战选择器（仅在未开始时显示）
        if !isTyping {
          Picker("选择挑战", selection: $selectedChallenge) {
            ForEach(Challenge.predefinedChallenges, id: \.id) { challenge in
              Text(challenge.title).tag(challenge)
            }
          }
          .pickerStyle(MenuPickerStyle())
          .foregroundColor(.white)
        }

        Spacer()

        // 文本显示和输入区域
        VStack(spacing: 20) {
          // 文本显示
          textDisplayView
            .padding(.horizontal, 40)

          // 隐藏的文本输入框
          TextField("", text: $userInput)
            .opacity(0)
            .frame(height: 0)
            .onChange(of: userInput) { newValue in
              handleTextInput(text: newValue)
            }
            .disabled(isFinished)
        }

        Spacer()

        // 统计信息
        statisticsView

        // 控制按钮
        if isFinished {
          HStack(spacing: 20) {
            Button("重新开始") {
              resetTest()
            }
            .buttonStyle(.borderedProminent)

            Button("分享结果") {
              shareResult()
            }
            .buttonStyle(.bordered)
          }
        } else if !isTyping {
          Button("开始测试") {
            startTyping()
          }
          .buttonStyle(.borderedProminent)
        }
      }
      .padding()
    }
    .frame(minWidth: 800, minHeight: 600)
    .onChange(of: selectedChallenge) { _ in
      resetTest()
    }
    .onReceive(timerPublisher) { _ in
      if let startTime = startTime, isTyping {
        elapsedTime = Date().timeIntervalSince(startTime)
      }
    }
  }

  // MARK: - Text Display
  private var textDisplayView: some View {
    let text = selectedChallenge.text
    let characters = Array(text)

    return Text(attributedText(for: characters))
      .font(.system(size: 24, design: .monospaced))
      .lineSpacing(8)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func attributedText(for characters: [Character]) -> AttributedString {
    var attributedString = AttributedString()

    for (index, character) in characters.enumerated() {
      var charString = AttributedString(String(character))

      if index < currentIndex {
        // 已输入的字符
        if index < userInput.count {
          let userChar = Array(userInput)[index]
          if userChar == character {
            // 正确字符
            charString.foregroundColor = .green
          } else {
            // 错误字符
            charString.foregroundColor = .red
            charString.backgroundColor = .red.opacity(0.3)
          }
        }
      } else if index == currentIndex {
        // 当前字符（光标位置）
        charString.backgroundColor = .white.opacity(0.3)
        charString.foregroundColor = .white
      } else {
        // 未输入的字符
        charString.foregroundColor = .gray
      }

      attributedString.append(charString)
    }

    return attributedString
  }

  // MARK: - Statistics View
  private var statisticsView: some View {
    HStack(spacing: 40) {
      StatisticItem(icon: "speedometer", value: String(format: "%.1f", wpm), label: "WPM")
      StatisticItem(icon: "checkmark.circle", value: "\(accuracy)%", label: "准确率")
      StatisticItem(icon: "textformat.123", value: "\(currentIndex)", label: "字符")
      StatisticItem(icon: "clock", value: String(format: "%.2fs", elapsedTime), label: "时间")
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
  }
}

extension ContentView {
  // MARK: - Input Handling

  private func handleTextInput(text: String) {
    if !isTyping {
      startTyping()
    }

    let targetChars = Array(selectedChallenge.text)
    let inputChars = Array(text)

    // 只处理新输入的字符
    if text.count > currentIndex {
      let newCharIndex = currentIndex
      if newCharIndex < targetChars.count && newCharIndex < inputChars.count {
        if inputChars[newCharIndex] == targetChars[newCharIndex] {
          correctChars += 1
        } else {
          errorCount += 1
        }
      }
    }

    // 更新当前输入位置
    currentIndex = min(text.count, selectedChallenge.text.count)

    // 检查是否完成 - 必须正确输入完所有字符
    if correctChars >= selectedChallenge.text.count {
      finishTyping()
    }
  }

  private func startTyping() {
    isTyping = true
    startTime = Date()
    elapsedTime = 0
  }

  private func finishTyping() {
    isTyping = false
    isFinished = true
  }

  private func resetTest() {
    userInput = ""
    isTyping = false
    isFinished = false
    startTime = nil
    elapsedTime = 0
    currentIndex = 0
    errorCount = 0
    correctChars = 0
  }

  private func shareResult() {
    let challengeURL = "speedtype://challenge/\(selectedChallenge.id)"
    let shareCard = ShareCardView(
      challengeTitle: selectedChallenge.title,
      wpm: Int(wpm.rounded()),
      accuracy: accuracy,
      timeUsed: elapsedTime,
      challengeURL: challengeURL
    )

    if let image = shareCard.asNSImage(size: CGSize(width: 400, height: 300)) {
      let pasteboard = NSPasteboard.general
      pasteboard.clearContents()
      pasteboard.writeObjects([image])

      // 显示成功提示
      DispatchQueue.main.async {
        let alert = NSAlert()
        alert.messageText = "分享成功"
        alert.informativeText = "打字测试结果图片已复制到剪贴板，你可以粘贴到任何地方分享！"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "确定")
        alert.runModal()
      }
    } else {
      // 显示错误提示
      DispatchQueue.main.async {
        let alert = NSAlert()
        alert.messageText = "分享失败"
        alert.informativeText = "无法生成分享图片，请重试。"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.runModal()
      }
    }
  }
}

#Preview {
  ContentView()
}