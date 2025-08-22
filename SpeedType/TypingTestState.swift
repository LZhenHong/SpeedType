//
//  TypingTestState.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import Foundation
import QuartzCore
import SwiftUI

/// 打字测试的核心状态模型
/// 集中管理所有测试相关的状态，避免分散在 UI 层
@Observable
class TypingTestState {
  // MARK: - Core State

  var selectedChallenge: Challenge = .predefinedChallenges[0]

  init() {
    updateTargetCharacters()
  }

  var userInput: String = ""
  var currentIndex: Int = 0

  // MARK: - Settings

  var isCaseSensitive: Bool = false
  var isStrictMode: Bool = true

  // MARK: - Test Progress

  var isTyping: Bool = false
  var isFinished: Bool = false
  private var startTime: CFTimeInterval?
  private var endTime: CFTimeInterval?

  // MARK: - Statistics

  var correctChars: Int = 0
  var errorCount: Int = 0

  // MARK: - Animation State

  var shouldShake: Bool = false
  private var shakeTask: Task<Void, Never>?

  // MARK: - Computed Properties

  /// 计算当前的经过时间
  var elapsedTime: TimeInterval {
    if let startTime {
      if let endTime {
        // 测试已结束，返回最终时间
        return endTime - startTime
      } else if isTyping {
        // 测试进行中，返回当前时间差
        return CACurrentMediaTime() - startTime
      }
    }
    return 0
  }

  var wpm: Double {
    guard elapsedTime > 0 else { return 0 }
    let minutes = elapsedTime / 60.0
    let words = Double(correctChars) / 5.0 // 标准：5个字符 = 1个单词
    return words / minutes
  }

  var accuracy: Int {
    let totalTyped = correctChars + errorCount
    guard totalTyped > 0 else { return 100 }
    return Int((Double(correctChars) / Double(totalTyped)) * 100)
  }

  var targetText: String {
    selectedChallenge.text
  }

  // 缓存字符数组，避免重复转换
  private var _targetCharacters: [Character] = []

  var targetCharacters: [Character] {
    _targetCharacters
  }

  private func updateTargetCharacters() {
    _targetCharacters = Array(selectedChallenge.text)
  }

  // MARK: - State Management

  func startTest() {
    startTime = CACurrentMediaTime()
    endTime = nil
    isTyping = true
  }

  func finishTest() {
    endTime = CACurrentMediaTime()
    isTyping = false
    isFinished = true
    // 清理输入状态，但保留统计数据
    userInput = ""
  }

  func resetTest() {
    isTyping = false
    isFinished = false
    startTime = nil
    endTime = nil
    currentIndex = 0
    correctChars = 0
    errorCount = 0
    userInput = ""
    shouldShake = false
    shakeTask?.cancel()
    shakeTask = nil
  }

  func changeChallenge(_ newChallenge: Challenge) {
    selectedChallenge = newChallenge
    updateTargetCharacters()
    resetTest()
  }

  func triggerShakeAnimation() {
    // 取消之前的动画任务
    shakeTask?.cancel()

    shouldShake = true

    // 使用 Task 替代 DispatchQueue，更好的取消支持
    shakeTask = Task { @MainActor in
      try? await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
      if !Task.isCancelled {
        shouldShake = false
      }
    }
  }

  // MARK: - Preview Helper (仅用于预览)

  func setMockTimeForPreview(startTime: CFTimeInterval, endTime: CFTimeInterval) {
    self.startTime = startTime
    self.endTime = endTime
  }
}
