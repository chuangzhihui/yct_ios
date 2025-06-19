//  swiftlint:disable:this file_name
//
//  UIColor+Application.swift
//

import UIKit

// MARK: - Application colors
extension UIColor {
  static let mainBackground = UIColor(named: "White")!
  static let brandPrimary = UIColor(named: "Blue")!
  static let buttonBackground = UIColor(named: "BlueLight")!
  static let textPlaceholder = UIColor(named: "DarkGray")!
  static let middleBackground = UIColor(named: "MiddleGray")!
  static let actionPlaceholder = UIColor(named: "LightGray")!
  static let placeholderBackground = UIColor(named: "Light")!
}

extension UIColor {
  public convenience init?(hex: String) {
    let r, g, b, a: CGFloat

    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      var hexColor = String(hex[start...]).lowercased()

      if hexColor.count == 6 {
        hexColor += "ff"
      }

      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255

          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }
    return nil
  }
}

// Extension to interpolate between two UIColor values.
// Based on http://stackoverflow.com/a/35853850

extension UIColor {
    func components() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        guard let c = cgColor.components else { return (0, 0, 0, 1) }
        if cgColor.numberOfComponents == 2 {
            return (c[0], c[0], c[0], c[1])
        } else {
            return (c[0], c[1], c[2], c[3])
        }
    }

    static func interpolate(from: UIColor, to: UIColor, with fraction: CGFloat) -> UIColor {
        let f = min(1, max(0, fraction))
        let c1 = from.components()
        let c2 = to.components()
        let r = c1.0 + (c2.0 - c1.0) * f
        let g = c1.1 + (c2.1 - c1.1) * f
        let b = c1.2 + (c2.2 - c1.2) * f
        let a = c1.3 + (c2.3 - c1.3) * f
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
