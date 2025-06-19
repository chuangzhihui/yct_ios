import UIKit

extension UITextField {
  func addBottomBorder() {
    let bottomLine = UIView()
    bottomLine.backgroundColor = UIColor.lightGray
    bottomLine.translatesAutoresizingMaskIntoConstraints = false
    self.borderStyle = .none
    self.addSubview(bottomLine)

    NSLayoutConstraint.activate([
      bottomLine.topAnchor.constraint(equalTo: bottomAnchor, constant: 1),
      bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
      bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottomLine.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}

protocol MyTextFieldDelegate: AnyObject {
  func textFieldDidDelete(_ textField: UITextField)
}

class MyTextField: UITextField {
  weak var myDelegate: MyTextFieldDelegate?

  override func deleteBackward() {
    super.deleteBackward()
    myDelegate?.textFieldDidDelete(self)
  }
}
