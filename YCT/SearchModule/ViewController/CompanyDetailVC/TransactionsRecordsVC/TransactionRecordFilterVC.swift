//
//  TransactionRecordFilterVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 23/11/2024.
//

import UIKit

class TransactionRecordFilterVC: UIViewController {

    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtHSCodeName: UITextField!
    @IBOutlet weak var txtSupplierName: UITextField!
    @IBOutlet weak var txtTradingPorts: UITextField!
    @IBOutlet weak var txtBillLandNum: UITextField!
    @IBOutlet weak var lblSupplierTitle: UILabel!
    
    @IBOutlet weak var lblTradingProductTitle: UILabel!
    @IBOutlet weak var lblHSCodeTitle: UILabel!
    @IBOutlet weak var lblTradingHoursTitle: UILabel!
    @IBOutlet weak var lblTradingPortsTitle: UILabel!
    @IBOutlet weak var lblBLNumTitle: UILabel!
    @IBOutlet weak var lblCountryRegionTitle: UILabel!
    @IBOutlet weak var lblSearchTitle: UILabel!
    
    // MARK: - Variable & Constants
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var startTime: Int = 0
    var endTime: Int = 0
    var dataType: Int = 0
    var selectedCountry: String = ""
    
    var TransactionsProductsSearchTxt: String = ""
    var TransactionshsCodeSearchTxt: String = ""
    var TransactionsSupplierSearchTxt: String = ""
    var TransactionsStartTimeSearchTxt: Int = 0
    var TransactionsEndTimeSearchTxt: Int = 0
    var TransactionsPortsSearchTxt: String = ""
    var TransactionsBillSearchTxt: String = ""
    var TransactionsCountrySearchTxt: String = ""
    
    var filterDataCallBack: ((_ product: String, _ hsCode: String, _ supplierName: String, _ startTime: Int, _ endTime: Int, _ ports: String, _ billNum: String, _ country: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        txtProductName.text = TransactionsProductsSearchTxt
        txtHSCodeName.text = TransactionshsCodeSearchTxt
        txtSupplierName.text = TransactionsSupplierSearchTxt
        startTime = TransactionsStartTimeSearchTxt
        endTime = TransactionsEndTimeSearchTxt
        txtTradingPorts.text = TransactionsPortsSearchTxt
        txtBillLandNum.text = TransactionsBillSearchTxt
        txtCountry.text = TransactionsCountrySearchTxt
        
        let date = Date.now.oneMonthBefore()
        startDate = date
        txtStartDate.text = date.formatToString()
        startTime = date.toTimestamp()
        
        let end = Date.now
        endDate = end
        txtEndDate.text = end.formatToString()
        endTime = end.toTimestamp()
    }
    
    func configureLanguage() {
        lblSupplierTitle.text = "Supplier".getString(for: dataType).localizeString() + " " + "Name".localizeString()
        txtSupplierName.placeholder = "Please Enter ".localizeString() + "Supplier".getString(for: dataType).localizeString() + " " + "Name".localizeString()

        txtProductName.placeholder = "Please Enter Product Name".localizeString()
        lblTradingProductTitle.text = "Trading Product".localizeString()
        lblHSCodeTitle.text = "HS Code".localizeString()
        lblTradingHoursTitle.text = "Trading hours".localizeString()
        lblTradingPortsTitle.text = "Trading Ports".localizeString()
        lblBLNumTitle.text = "B/L Number".localizeString()
        lblCountryRegionTitle.text = "Country/Region".localizeString()
        lblSearchTitle.text = "Search".localizeString()
        txtCountry.placeholder = "Select Country".localizeString()
        txtHSCodeName.placeholder = "Please Enter HS Code".localizeString()
        txtTradingPorts.placeholder = "Please Enter Trading Ports".localizeString()
        txtBillLandNum.placeholder = "Please Enter B/L Number".localizeString()
    }
    
    func moveToSearchCountryVC() {
        let countryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCountryVC") as! SearchCountryVC
        countryVC.onSelectedCountry = { [weak self] (countryName, countryCode) in
            self?.txtCountry.text =  countryName
            self?.selectedCountry = countryName
        }
        
        present(countryVC, animated: true, completion: nil)
    }

    
    @IBAction func startDate(_ sender: UIButton) {
        DateUtility.presentDatePicker(from: self, initialDate: startDate) { [weak self] selectedDate in
            self?.startDate = selectedDate
            self?.txtStartDate.text = selectedDate.formatToString()
            self?.startTime = selectedDate.toTimestamp()
        }
    }
    
    @IBAction func endDate(_ sender: UIButton) {
        DateUtility.presentDatePicker(from: self, initialDate: endDate) { [weak self] selectedDate in
            self?.endDate = selectedDate
            self?.txtEndDate.text = selectedDate.formatToString()
            self?.endTime = selectedDate.toTimestamp()
        }
    }
    
    @IBAction func crossTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }

    @IBAction func countryTapped(_ sender: UIButton) {
        moveToSearchCountryVC()
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        let products = txtProductName.text ?? ""
        let hsCode = txtHSCodeName.text ?? ""
        let supplierName = txtSupplierName.text ?? ""
        let startTime = startTime
        let endTime = endTime
        let ports = txtTradingPorts.text ?? ""
        let bill = txtBillLandNum.text ?? ""
        let country = txtCountry.text ?? ""
        dismiss(animated: false) {
            self.filterDataCallBack?(products, hsCode, supplierName, startTime, endTime, ports, bill, country)
        }
    }
}
