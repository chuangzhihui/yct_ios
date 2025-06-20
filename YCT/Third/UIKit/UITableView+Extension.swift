import UIKit

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }

extension UITableView {

  func registerReusedCell<T: UITableViewCell>(cellNib: T.Type, bundle: Bundle? = nil) {
    let nib = UINib(nibName: cellNib.dequeueIdentifier, bundle: bundle)
    self.register(nib, forCellReuseIdentifier: cellNib.dequeueIdentifier)
  }

  func dequeueReusable<T: UITableViewCell>(cellNib: T.Type, indexPath: IndexPath) -> T? {
    return self.dequeueReusableCell(withIdentifier: cellNib.dequeueIdentifier, for: indexPath) as? T
  }

  func registerReusedHeaderView<T: UITableViewHeaderFooterView>(headerNib: T.Type, bundle: Bundle? = nil) {
    let nib = UINib(nibName: headerNib.dequeueIdentifier, bundle: bundle)
    self.register(nib, forHeaderFooterViewReuseIdentifier: headerNib.dequeueIdentifier)
  }

  func dequeueReusableHeaderView<T: UITableViewHeaderFooterView>(headerNib: T.Type) -> T? {
    return self.dequeueReusableHeaderFooterView(withIdentifier: headerNib.dequeueIdentifier) as? T
  }
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completion()
        })
        self.reloadData()
        CATransaction.commit()
    }
    func scrollToBottom()  {
        let point = CGPoint(x: 0, y: contentSize.height + contentInset.bottom - frame.height)
        if point.y >= 0{
            setContentOffset(point, animated: true)
        }
    }
}
