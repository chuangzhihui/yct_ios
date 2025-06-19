//
//  UIView+Subviews.swift
//

import UIKit

public protocol ReusableView: AnyObject { }

extension ReusableView where Self: UIView {
  static var dequeueIdentifier: String {
    String(describing: self)
  }
}

protocol NibIdentifiable {
  static var nibIdentifier: String { get }
}

extension NibIdentifiable {
  static var nib: UINib {
    UINib(nibName: nibIdentifier, bundle: nil)
  }
}

extension UIView: NibIdentifiable {
  static var nibIdentifier: String {
    String(describing: self)
  }
}

extension UIViewController: NibIdentifiable {
  static var nibIdentifier: String {
    String(describing: self)
  }
}

extension UIView {
  
  func addSubviews(_ views: UIView...) {
    views.forEach(addSubview)
  }
}

extension UIView {
  func constrainCentered(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    
    let verticalContraint = NSLayoutConstraint(
      item: subview,
      attribute: .centerY,
      relatedBy: .equal,
      toItem: self,
      attribute: .centerY,
      multiplier: 1.0,
      constant: 0
    )
    
    let horizontalContraint = NSLayoutConstraint(
      item: subview,
      attribute: .centerX,
      relatedBy: .equal,
      toItem: self,
      attribute: .centerX,
      multiplier: 1.0,
      constant: 0
    )
    
    let heightContraint = NSLayoutConstraint(
      item: subview,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: subview.frame.height
    )
    
    let widthContraint = NSLayoutConstraint(
      item: subview,
      attribute: .width,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: subview.frame.width
    )
    
    addConstraints([
      horizontalContraint,
      verticalContraint,
      heightContraint,
      widthContraint,
    ])
  }
  
  func constrainToEdges(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    
    let topContraint = NSLayoutConstraint(
      item: subview,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: 1.0,
      constant: 0
    )
    
    let bottomConstraint = NSLayoutConstraint(
      item: subview,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self,
      attribute: .bottom,
      multiplier: 1.0,
      constant: 0
    )
    
    let leadingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .leading,
      relatedBy: .equal,
      toItem: self,
      attribute: .leading,
      multiplier: 1.0,
      constant: 0
    )
    
    let trailingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: self,
      attribute: .trailing,
      multiplier: 1.0,
      constant: 0
    )
    
    addConstraints([
      topContraint,
      bottomConstraint,
      leadingContraint,
      trailingContraint,
    ])
  }
}

extension UIScrollView {
  func scrollToTop() {
    let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
    setContentOffset(desiredOffset, animated: true)
  }
}
