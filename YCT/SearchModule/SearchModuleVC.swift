//
//  ProductFormVC.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 10/27/24.
//

import UIKit
import JXCategoryView

@objc
class SearchModuleVC: UIViewController, JXCategoryListContentViewDelegate {
    
    @objc var topY:CGFloat = 0
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the navigation bar
//        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Hide the tab bar by setting its frame height to 0
//        if let tabBar = tabBarController?.tabBar {
//            tabBar.isHidden = true
//            var frame = tabBar.frame
//            frame.size.height = 0
//            tabBar.frame = frame
//        }
        
        // Set background color
//        view.backgroundColor = UIColor.white
        
        // Add child view controller (ProductVC)
        let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        addChild(productVC)
        view.addSubview(productVC.view)
        
        // Apply top inset
        let topInset: CGFloat = 100 // Change this to your desired inset
        productVC.view.frame = view.bounds.inset(by: UIEdgeInsets(top: topY, left: 0, bottom: 0, right: 0))
        
        productVC.didMove(toParent: self)
    }

    
    func listView() -> UIView! {
        view.backgroundColor = .black
        return self.view
    }
}
