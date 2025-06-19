import UIKit

class CustomButton: UIButton {
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        self.backgroundColor = UIColor.mainBackground
        self.tintColor = UIColor.brandPrimary
      } else {
        self.backgroundColor = UIColor.buttonBackground
        self.tintColor = UIColor.mainBackground
      }
    }
  }
}
