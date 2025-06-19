//
//  BaseViewController.swift
//  YCT
//
//  Created by Fenris on 7/19/24.
//

import UIKit
import MBProgressHUD
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /** Show Alert with message */
    
    func  alertWithMessage(_ message:String){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    /** Pop VC methods */
    func popBackToParentVC()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    /** Hide Indicator  */
    func hideIndicator() {
        //        self.view.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    /** Show Indicator with message */
    func showIndicator(withTitle title: String) {
        let Indicator = MBProgressHUD.showAdded(to: view, animated: true) // .showAdded(to: self.view, animated: true)
        Indicator.label.text = title
        Indicator.label.numberOfLines = 0 // Allow multiple lines
        Indicator.label.lineBreakMode = .byWordWrapping
        Indicator.show(animated: true)
    }
}
