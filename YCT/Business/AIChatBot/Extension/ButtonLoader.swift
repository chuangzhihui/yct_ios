//
//  ButtonLoader.swift
//  YCT
//
//  Created by Noman Umar on 12/08/2024.
//

import Foundation
import UIKit

extension UIButton {
    
    private struct AssociatedKeys {
        static var activityIndicator = "activityIndicator"
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoader() {
        // Disable button interaction
        self.isUserInteractionEnabled = false
        
        // Set the title to empty to show the loader
        self.setTitle("", for: .normal)
        
        if activityIndicator == nil {
            // Create and configure the activity indicator
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = self.titleLabel?.textColor
            activityIndicator.color = .white
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(activityIndicator)
            
            // Center the activity indicator in the button
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            
            self.activityIndicator = activityIndicator
        }
        
        // Start animating the activity indicator
        activityIndicator?.startAnimating()
    }
    
    func hideLoader() {
        // Enable button interaction
        self.isUserInteractionEnabled = true
        
        // Stop the activity indicator and remove it from the button
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
        
        // Restore the button title
        self.setTitle("Button Title", for: .normal)
    }
}
