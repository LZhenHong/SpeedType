//
//  ShareCardView.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import AppKit
import SwiftUI

struct ShareCardView: View {
  let challengeTitle: String
  let wpm: Int
  let accuracy: Int
  let timeUsed: TimeInterval
  let challengeURL: String

  var body: some View {
    VStack(spacing: 15) {
      Text("SpeedType 打字测试结果")
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.black)

      Text(challengeTitle)
        .font(.headline)
        .foregroundColor(.black)

      HStack(spacing: 30) {
        VStack {
          Text("\(wpm)")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.blue)
          Text("WPM")
            .font(.caption)
            .foregroundColor(.gray)
        }
        
        VStack {
          Text("\(accuracy)%")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.green)
          Text("准确率")
            .font(.caption)
            .foregroundColor(.gray)
        }
        
        VStack {
          Text(String(format: "%.1fs", timeUsed))
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.orange)
          Text("用时")
            .font(.caption)
            .foregroundColor(.gray)
        }
      }

      if let qrImage = QRCodeGenerator.generate(from: challengeURL) {
        Image(nsImage: qrImage)
          .resizable()
          .frame(width: 80, height: 80)
      }

      Text("扫码挑战同样的文本！")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding(20)
    .frame(width: 400, height: 300)
    .background(Color.white)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    )
  }
}

extension View {
  func asNSImage(size: CGSize) -> NSImage? {
    let controller = NSHostingController(rootView: self)
    controller.view.frame = CGRect(origin: .zero, size: size)
    
    // 确保视图有正确的尺寸
    controller.view.wantsLayer = true
    controller.view.layer?.backgroundColor = NSColor.white.cgColor
    
    // 强制布局
    controller.view.layoutSubtreeIfNeeded()
    
    guard let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: controller.view.bounds) else {
      return nil
    }
    
    controller.view.cacheDisplay(in: controller.view.bounds, to: bitmapRep)
    
    let image = NSImage(size: size)
    image.addRepresentation(bitmapRep)
    
    return image
  }
}
