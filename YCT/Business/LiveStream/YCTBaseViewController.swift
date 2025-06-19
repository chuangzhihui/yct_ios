//
//  YCTBaseViewController.swift
//  YCT
//
//  Created by Lucky on 17/03/2024.
//

import UIKit

@objc class YCTSwiftBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navi_back"), style: .plain, target: self, action: #selector(self.goBack))
    }
}

extension YCTSwiftBaseViewController {
    @objc func goBack(_ animation: Bool = true) {
        self.navigationController?.popViewController(animated: animation)
    }
}
