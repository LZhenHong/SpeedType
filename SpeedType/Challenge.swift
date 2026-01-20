//
//  Challenge.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import Foundation

struct Challenge: Identifiable, Hashable {
  let id: String
  let title: String
  let text: String

  static let predefinedChallenges: [Challenge] = {
    var challenges = [
      Challenge(
        id: "alphabet-az",
        title: "Alphabet (A-Z)",
        text: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      ),
      Challenge(
        id: "keyboard-qwerty",
        title: "Keyboard Layout (QWERTY)",
        text: "QWERTYUIOPASDFGHJKLZXCVBNM"
      ),
    ]

    #if DEBUG
    challenges.append(
      Challenge(
        id: "test-qwer",
        title: "Test (QWER)",
        text: "QWER"
      ))
    #endif

    return challenges
  }()
}
