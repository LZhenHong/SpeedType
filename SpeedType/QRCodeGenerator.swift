//
//  QRCodeGenerator.swift
//  SpeedType
//
//  Created by Eden on 2025/8/7.
//

import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation

enum QRCodeGenerator {
  static func generate(from string: String) -> NSImage? {
    guard let data = string.data(using: .utf8) else { return nil }

    let filter = CIFilter(name: "CIQRCodeGenerator")!
    filter.setValue(data, forKey: "inputMessage")

    guard let ciImage = filter.outputImage else { return nil }

    // Scale up the image for better quality
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    let scaledImage = ciImage.transformed(by: transform)

    let rep = NSCIImageRep(ciImage: scaledImage)
    let nsImage = NSImage(size: rep.size)
    nsImage.addRepresentation(rep)

    return nsImage
  }
}
