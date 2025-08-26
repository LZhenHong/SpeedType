//
//  TypingEngine.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import Foundation
import SwiftUI

/// 打字测试的核心引擎
/// 处理所有打字逻辑，与 UI 完全分离
enum TypingEngine {
  /// 处理用户输入，更新状态
  /// - Parameters:
  ///   - newInput: 新的用户输入
  ///   - state: 当前测试状态
  static func handleInput(_ newInput: String, state: TypingTestState) {
    guard !state.isFinished else {
      return
    }

    // 如果输入为空，不自动开始测试
    guard !newInput.isEmpty else {
      return
    }

    // 自动开始测试
    if !state.isTyping {
      state.startTest()
    }

    let targetChars = state.targetCharacters
    let inputChars = Array(newInput)

    // 严格模式：验证所有输入字符
    if state.isStrictMode {
      let errorIndex = findFirstError(
        inputChars: inputChars, targetChars: targetChars, caseSensitive: state.isCaseSensitive
      )
      if let errorIndex {
        // 回退到错误位置
        state.userInput = String(newInput.prefix(errorIndex))
        state.currentIndex = errorIndex
        state.triggerShakeAnimation()
        return
      }
    }

    // 处理新增字符
    let newCharCount = inputChars.count - state.currentIndex
    if newCharCount > 0 {
      processNewCharacters(
        inputChars: inputChars,
        targetChars: targetChars,
        startIndex: state.currentIndex,
        count: newCharCount,
        caseSensitive: state.isCaseSensitive,
        state: state
      )
    }

    // 更新状态
    state.currentIndex = min(inputChars.count, targetChars.count)
    state.userInput = newInput

    // 检查完成
    if state.currentIndex >= targetChars.count {
      state.finishTest()
    }
  }

  /// 查找第一个错误字符的位置
  private static func findFirstError(
    inputChars: [Character], targetChars: [Character], caseSensitive: Bool
  ) -> Int? {
    for (index, inputChar) in inputChars.enumerated() {
      guard index < targetChars.count else { break }
      if !charactersMatch(inputChar, targetChars[index], caseSensitive: caseSensitive) {
        return index
      }
    }
    return nil
  }

  /// 处理新增的字符
  private static func processNewCharacters(
    inputChars: [Character], targetChars: [Character], startIndex: Int, count: Int,
    caseSensitive: Bool, state: TypingTestState
  ) {
    let endIndex = min(startIndex + count, min(inputChars.count, targetChars.count))

    var correctCount = 0
    var errorCount = 0
    var hasError = false

    for index in startIndex ..< endIndex {
      let isMatch = charactersMatch(
        inputChars[index], targetChars[index], caseSensitive: caseSensitive
      )

      if isMatch {
        correctCount += 1
      } else {
        errorCount += 1
        hasError = true
      }
    }

    // 批量更新状态，减少@Observable触发次数
    state.correctChars += correctCount
    state.errorCount += errorCount

    if hasError {
      state.triggerShakeAnimation()
    }
  }

  /// 字符匹配检查
  private static func charactersMatch(_ input: Character, _ target: Character, caseSensitive: Bool)
    -> Bool
  {
    caseSensitive ? input == target : input.lowercased() == target.lowercased()
  }

  /// 生成带样式的文本显示
  /// - Parameters:
  ///   - state: 当前测试状态
  /// - Returns: 带样式的 AttributedString
  static func generateAttributedText(for state: TypingTestState) -> AttributedString {
    var attributedString = AttributedString()
    let characters = state.targetCharacters
    let userInputChars = Array(state.userInput)

    for (index, character) in characters.enumerated() {
      var charString = AttributedString(String(character))

      if index < state.currentIndex {
        // 已输入的字符
        if index < userInputChars.count {
          let userChar = userInputChars[index]
          let isMatch =
            state.isCaseSensitive
              ? userChar == character
              : userChar.lowercased() == character.lowercased()

          if isMatch {
            // 正确字符
            charString.foregroundColor = .green
          } else {
            // 错误字符
            charString.foregroundColor = .red
            charString.backgroundColor = .red.opacity(0.3)
          }
        }
      } else if index == state.currentIndex {
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
}
