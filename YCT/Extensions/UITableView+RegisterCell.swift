//
//  UITableView+RegisterCell.swift
//  YCT
//
//  Created by Lucky on 21/03/2024.
//

import Foundation
import UIKit

extension UITableView {

    public func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.dequeueIdentifier)
    }

    public func register<T: UITableViewHeaderFooterView>(headerFooterClass: T.Type) {
        register(headerFooterClass, forHeaderFooterViewReuseIdentifier: headerFooterClass.dequeueIdentifier)
    }

    public func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: cellClass.dequeueIdentifier) as? T
    }

    public func dequeue<T: UITableViewHeaderFooterView>(headerFooterClass: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: headerFooterClass.dequeueIdentifier) as? T
    }

    public func dequeue<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellClass.dequeueIdentifier, for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(cellClass.dequeueIdentifier) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }

}

extension UITableView {
    //WARNING: - To use these functions, the name of the Nib, Class and Cell's Id MUST-BE-SAME!!! with each other.
    
    func register<T: UITableViewCell>(cellNib: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: cellNib.dequeueIdentifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: cellNib.dequeueIdentifier)
    }
    
    func dequeueReusable<T: UITableViewCell>(cellNib: T.Type, indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: cellNib.dequeueIdentifier, for: indexPath) as! T
        
        return cell
    }
}

extension UITableViewCell {

    static var dequeueIdentifier: String {
        return String(describing: self)
    }

}

extension UITableViewHeaderFooterView {

    static var dequeueIdentifier: String {
        return String(describing: self)
    }

}
