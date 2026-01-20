//
//  TypingTestState.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import Foundation
import QuartzCore
import SwiftUI

// MARK: - Typing Test State

/// 打字测试的核心状态模型
/// 集中管理所有测试相关的状态，避免分散在 UI 层
@Observable
class TypingTestState {
  // MARK: - Core State

  var selectedChallenge: Challenge = .predefinedChallenges[0] {
    didSet { updateTargetCharacters() }
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

  // MARK: - Cached Properties

  private var _targetCharacters: [Character] = []
  var targetCharacters: [Character] { _targetCharacters }

  // MARK: - Initialization

  init() {
    updateTargetCharacters()
  }

  // MARK: - Computed Properties

  var elapsedTime: TimeInterval {
    guard let startTime else { return 0 }
    if let endTime { return endTime - startTime }
    return isTyping ? CACurrentMediaTime() - startTime : 0
  }

  var wpm: Double {
    guard elapsedTime > 0 else { return 0 }
    let minutes = elapsedTime / 60.0
    let words = Double(correctChars) / 5.0
    return words / minutes
  }

  var accuracy: Int {
    let totalTyped = correctChars + errorCount
    guard totalTyped > 0 else { return 100 }
    return Int((Double(correctChars) / Double(totalTyped)) * 100)
  }

  var targetText: String { selectedChallenge.text }

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
    resetTest()
  }

  func triggerShakeAnimation() {
    shakeTask?.cancel()
    shouldShake = true

    shakeTask = Task { @MainActor in
      try? await Task.sleep(nanoseconds: 600_000_000)
      if !Task.isCancelled { shouldShake = false }
    }
  }

  // MARK: - Private Methods

  private func updateTargetCharacters() {
    _targetCharacters = Array(selectedChallenge.text)
  }

  // MARK: - Preview Helper

  func setMockTimeForPreview(startTime: CFTimeInterval, endTime: CFTimeInterval) {
    self.startTime = startTime
    self.endTime = endTime
  }
}
