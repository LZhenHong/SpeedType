//
//  AlertHelper.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import AppKit
import Foundation

/// 统一的弹窗助手
/// 消除重复的 NSAlert 代码，提供一致的用户体验
enum AlertHelper {
  /// 显示成功提示
  /// - Parameters:
  ///   - title: 标题
  ///   - message: 详细信息
  static func showSuccess(title: String, message: String) {
    DispatchQueue.main.async {
      let alert = NSAlert()
      alert.messageText = title
      alert.informativeText = message
      alert.alertStyle = .informational
      alert.addButton(withTitle: "确定")
      alert.runModal()
    }
  }

  /// 显示错误提示
  /// - Parameters:
  ///   - title: 标题
  ///   - message: 详细信息
  static func showError(title: String, message: String) {
    DispatchQueue.main.async {
      let alert = NSAlert()
      alert.messageText = title
      alert.informativeText = message
      alert.alertStyle = .warning
      alert.addButton(withTitle: "确定")
      alert.runModal()
    }
  }

  /// 显示分享成功提示
  static func showShareSuccess() {
    showSuccess(
      title: "分享成功",
      message: "打字测试结果图片已复制到剪贴板，你可以粘贴到任何地方分享！"
    )
  }

  /// 显示分享失败提示
  static func showShareError() {
    showError(
      title: "分享失败",
      message: "无法生成分享图片，请重试。"
    )
  }
}
