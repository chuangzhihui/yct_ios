//
//  FilterSupplierVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 24/11/2024.
//

import UIKit

class FilterSupplierVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtSupplier: UITextField!
    @IBOutlet weak var txtCountryName: UITextField!
    
    @IBOutlet weak var lblRegionTitle: UILabel!
    @IBOutlet weak var lblSupplierNameTitle: UILabel!
    @IBOutlet weak var lblSearchTitle: UILabel!
    // MARK: - Variable & Constants
    var supplierSearchText: String = ""
    var countrySearchText: String = ""
    var supplierFilterCallBack: ((_ supplierTxt: String, _ countryText: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSupplier.text = supplierSearchText
        txtCountryName.text = countrySearchText
        configureLanguage()
    }
    
    
    func configureLanguage() {
        txtSupplier.placeholder = "Please enter supplier name".localizeString()
        txtCountryName.placeholder = "Please enter Country/Region".localizeString()
        lblRegionTitle.text = "Country/Region".localizeString()
        lblSupplierNameTitle.text = "Supplier Name".localizeString()
        lblSearchTitle.text = "Search".localizeString()
    }

    @IBAction func crossTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        let suplierTxt = txtSupplier.text ?? ""
        let countryTxt = txtCountryName.text ?? ""
        
        dismiss(animated: false) {
            self.supplierFilterCallBack?(suplierTxt, countryTxt)
        }
    }
}
