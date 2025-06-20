import UIKit
import Foundation

// MARK: - Designable Extension

@IBDesignable
extension UIView {
  
//  @IBInspectable
//  /// Should the corner be as circle
//  var circleCorner: Bool {
//    get {
//      return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
//    }
//    set {
//      cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
//    }
//  }
//
//  @IBInspectable
//  /// Corner radius of view; also inspectable from Storyboard.
//  var cornerRadius: CGFloat {
//    get {
//      return layer.cornerRadius
//    }
//    set {
//      layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
//      //abs(CGFloat(Int(newValue * 100)) / 100)
//    }
//  }
  
  //    @IBInspectable
  //    /// Border color of view; also inspectable from Storyboard.
  //    var borderColor: UIColor? {
  //        get {
  //            guard let color = layer.borderColor else {
  //                return nil
  //            }
  //            return UIColor(cgColor: color)
  //        }
  //        set {
  //            guard let color = newValue else {
  //                layer.borderColor = nil
  //                return
  //            }
  //            layer.borderColor = color.cgColor
  //        }
  //    }
  
  //    @IBInspectable
  //    /// Border width of view; also inspectable from Storyboard.
  //    var borderWidth: CGFloat {
  //        get {
  //            return layer.borderWidth
  //        }
  //        set {
  //            layer.borderWidth = newValue
  //        }
  //    }
  
//  @IBInspectable
//  /// Shadow color of view; also inspectable from Storyboard.
//  var shadowColor: UIColor? {
//    get {
//      guard let color = layer.shadowColor else {
//        return nil
//      }
//      return UIColor(cgColor: color)
//    }
//    set {
//      layer.shadowColor = newValue?.cgColor
//    }
//  }
//
//  @IBInspectable
//  /// Shadow offset of view; also inspectable from Storyboard.
//  var shadowOffset: CGSize {
//    get {
//      return layer.shadowOffset
//    }
//    set {
//      layer.shadowOffset = newValue
//    }
//  }
//
//  @IBInspectable
//  /// Shadow opacity of view; also inspectable from Storyboard.
//  var shadowOpacity: Double {
//    get {
//      return Double(layer.shadowOpacity)
//    }
//    set {
//      layer.shadowOpacity = Float(newValue)
//    }
//  }
//
//  @IBInspectable
//  /// Shadow radius of view; also inspectable from Storyboard.
//  var shadowRadius: CGFloat {
//    get {
//      return layer.shadowRadius
//    }
//    set {
//      layer.shadowRadius = newValue
//    }
//  }
//
//  @IBInspectable
//  /// Shadow path of view; also inspectable from Storyboard.
//  var shadowPath: CGPath? {
//    get {
//      return layer.shadowPath
//    }
//    set {
//      layer.shadowPath = newValue
//    }
//  }
//
//  @IBInspectable
//  /// Should shadow rasterize of view; also inspectable from Storyboard.
//  /// cache the rendered shadow so that it doesn't need to be redrawn
//  var shadowShouldRasterize: Bool {
//    get {
//      return layer.shouldRasterize
//    }
//    set {
//      layer.shouldRasterize = newValue
//    }
//  }
//
//  @IBInspectable
//  /// Should shadow rasterize of view; also inspectable from Storyboard.
//  /// cache the rendered shadow so that it doesn't need to be redrawn
//  var shadowRasterizationScale: CGFloat {
//    get {
//      return layer.rasterizationScale
//    }
//    set {
//      layer.rasterizationScale = newValue
//    }
//  }
//
//  @IBInspectable
//  /// Corner radius of view; also inspectable from Storyboard.
//  var maskToBounds: Bool {
//    get {
//      return layer.masksToBounds
//    }
//    set {
//      layer.masksToBounds = newValue
//    }
//  }
}


// MARK: - Properties

extension UIView {
    
    @IBInspectable
    var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 1,
                   shadowRadius: CGFloat = 2.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    @IBInspectable var makeCircle: Bool {
        get {
            return self.layer.cornerRadius > 0
        }
        set {
            if newValue == true {
                self.layer.cornerRadius = self.layer.frame.height / 2
            }
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
  
  /// Size of view.
  var size: CGSize {
    get {
      return self.frame.size
    }
    set {
      self.width = newValue.width
      self.height = newValue.height
    }
  }
  
  /// Width of view.
  var width: CGFloat {
    get {
      return self.frame.size.width
    }
    set {
      self.frame.size.width = newValue
    }
  }
  
  /// Height of view.
  var height: CGFloat {
    get {
      return self.frame.size.height
    }
    set {
      self.frame.size.height = newValue
    }
  }
}

extension UIView {
  
  func superview<T>(of type: T.Type) -> T? {
    return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
  }
  
}


// MARK: - Methods

extension UIView {
  
  typealias Configuration = (UIView) -> Swift.Void
  
  func config(configurate: Configuration?) {
    configurate?(self)
  }
  
  /// Set some or all corners radiuses of view.
  ///
  /// - Parameters:
  ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
  ///   - radius: radius for selected corners.
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let shape = CAShapeLayer()
    shape.path = maskPath.cgPath
    layer.mask = shape
  }
}

extension UIView {
  
  func searchVisualEffectsSubview() -> UIVisualEffectView? {
    if let visualEffectView = self as? UIVisualEffectView {
      return visualEffectView
    } else {
      for subview in subviews {
        if let found = subview.searchVisualEffectsSubview() {
          return found
        }
      }
    }
    return nil
  }
  
  /// This is the function to get subViews of a view of a particular type
  /// https://stackoverflow.com/a/45297466/5321670
  func subViews<T : UIView>(type : T.Type) -> [T]{
    var all = [T]()
    for view in self.subviews {
      if let aView = view as? T{
        all.append(aView)
      }
    }
    return all
  }
  
  
  /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
  /// https://stackoverflow.com/a/45297466/5321670
  func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
    var all = [T]()
    func getSubview(view: UIView) {
      if let aView = view as? T{
        all.append(aView)
      }
      guard view.subviews.count>0 else { return }
      view.subviews.forEach{ getSubview(view: $0) }
    }
    getSubview(view: self)
    return all
  }
}
