import UIKit

//enum FontWeight {
//  case thin
//  case extraLight
//  case light
//  case regular
//  case medium
//  case semiBold
//  case bold
//  case extraBold
//  case black
//}

extension UIFont {
//  static func customFont(ofSize: CGFloat, weight: FontWeight) -> UIFont {
//    switch weight {
//    case .thin:
//      return UIFont(name: "Montserrat-Thin", size: ofSize)!
//    case .extraLight:
//      return UIFont(name: "Montserrat-ExtraLight", size: ofSize)!
//    case .light:
//      return UIFont(name: "Montserrat-Light", size: ofSize)!
//    case .regular:
//      return UIFont(name: "Montserrat-Regular", size: ofSize)!
//    case .medium:
//      return UIFont(name: "Montserrat-Medium", size: ofSize)!
//    case .semiBold:
//      return UIFont(name: "Montserrat-SemiBold", size: ofSize)!
//    case .bold:
//      return UIFont(name: "Montserrat-Bold", size: ofSize)!
//    case .extraBold:
//      return UIFont(name: "Montserrat-ExtraBold", size: ofSize)!
//    case .black:
//      return UIFont(name: "Montserrat-Black", size: ofSize)!
//    }
//  }

  static func systemFont(ofSize: CGFloat, weight: Int) -> UIFont {
    UIFont.systemFont(ofSize: ofSize, weight: .weight(weight))
  }

  static let tabBarItem = UIFont.systemFont(ofSize: 12, weight: .regular)
  
  static let headerTitle = UIFont.systemFont(ofSize: 40, weight: .bold)
  static let headerSubtitle = UIFont.systemFont(ofSize: 14, weight: .medium)

  static let textPlaceholder = UIFont.systemFont(ofSize: 14, weight: .regular)
  static let textAction = UIFont.systemFont(ofSize: 14, weight: .medium)
  static let textButton = UIFont.systemFont(ofSize: 14, weight: .semibold)

  static let buttonNormal = UIFont.systemFont(ofSize: 16, weight: .regular)
  static let buttonHighlighted = UIFont.systemFont(ofSize: 16, weight: .semibold)

  static let pageItemTitle = UIFont.systemFont(ofSize: 14, weight: .bold)
  static let pageItemContent = UIFont.systemFont(ofSize: 14, weight: .regular)
}

extension Int {
  func fontWeight(_ w: Int) -> UIFont.Weight {
    UIFont.Weight.weight(w)
  }
}

extension UIFont.Weight {
  static func weight(_ w: Int) -> UIFont.Weight {
    switch w {
    case 100:
      return .ultraLight
    case 200:
      return .thin
    case 300:
      return .light
    case 400:
      return .regular
    case 500:
      return .medium
    case 600:
      return .semibold
    case 700:
      return .bold
    case 800:
      return .heavy
    case 900:
      return .black
    default:
      return .regular
    }
  }
}

