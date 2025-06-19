//
//  PaymentVC.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 12/8/24.
//
import UIKit

enum PaymentType: String {
    case Basic
    case Premium
    case Enterprise
    
    func queryCount() -> String {
        switch self {
        case .Basic:
            return "(1 Query)"
        case .Premium:
            return "(30 Query)"
        case .Enterprise:
            return "(100 Query)"
        }
    }
    
    func discountString() -> String {
        switch self {
        case .Basic:
            return ""
        case .Premium:
            return "(74% off)"
        case .Enterprise:
            return "(58% off)"
        }
    }
}

struct PaymentModel {
    var type: PaymentType
    var credits: String
    var price: String
}

class PaymentVC: UIViewController {

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblDescrip: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblMainBuyer: UILabel!
    @IBOutlet weak var lblSearchListTitle: UILabel!
    @IBOutlet weak var lblSearchListDescrip: UILabel!
    @IBOutlet weak var lblBuyerDetail: UILabel!
    @IBOutlet weak var lblTransOverview: UILabel!
    @IBOutlet weak var lblTransDescrip: UILabel!
    @IBOutlet weak var lblTradePartner: UILabel!
    @IBOutlet weak var lblTradePartnerDescrip: UILabel!
    @IBOutlet weak var lblHSCodeTitle: UILabel!
    @IBOutlet weak var lblHSCodeDescrip: UILabel!
    @IBOutlet weak var lblTradingAreaTitle: UILabel!
    @IBOutlet weak var lblTradingAreaDescrip: UILabel!
    @IBOutlet weak var lblStats: UILabel!
    @IBOutlet weak var lblPortDescrip: UILabel!
    @IBOutlet weak var lblMainSupplier: UILabel!
    @IBOutlet weak var lblSSearchList: UILabel!
    @IBOutlet weak var lblSDescrip: UILabel!
    @IBOutlet weak var lblSupplierDetail: UILabel!
    @IBOutlet weak var lblSTransOverview: UILabel!
    @IBOutlet weak var lblSTransDescrip: UILabel!
    @IBOutlet weak var lblSTransPartner: UILabel!
    @IBOutlet weak var lblSTransPartnerDescrip: UILabel!
    @IBOutlet weak var lblSHSCode: UILabel!
    @IBOutlet weak var lblSHSCodeDescrip: UILabel!
    @IBOutlet weak var lblSTradingArea: UILabel!
    @IBOutlet weak var lblSTradingAreaDescrip: UILabel!
    @IBOutlet weak var lblSPortStats: UILabel!
    @IBOutlet weak var lblSPortDescrip: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel!
    @IBOutlet weak var lblBuyerSupplier: UILabel!
    @IBOutlet weak var lblBuyerSupplierDescrip: UILabel!
    
    @IBOutlet weak var lblCustomData: UILabel!
    @IBOutlet weak var lblCustomDataSearchList: UILabel!
    @IBOutlet weak var lblCustomDataSearchListDescrip: UILabel!
    @IBOutlet weak var lblBuyerTradeData: UILabel!
    @IBOutlet weak var lblBuyerTradeDescrip: UILabel!
    @IBOutlet weak var lblSupplierTradeData: UILabel!
    @IBOutlet weak var lblSupplierTradeDescrip: UILabel!
    // MARK: - Variable & Constants
    var selectedIndex: Int? // To keep track of the selected cell index
    var paymentData: [PaymentModel] = [
//        PaymentModel(type: .Basic, credits: "2", price: "5"),
        PaymentModel(type: .Premium, credits: "60", price: "40"),
        PaymentModel(type: .Enterprise, credits: "200", price: "105"),
    ]
    var selectedPayment: PaymentModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLanguage()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
    }
    
    //MARK: - Custom Functions
    func configureLanguage() {
        lblTitle.text = "You have exceed your points limit, please purchase a new plan for explore".localizeString()
        lblBuy.text = "Buy".localizeString()
        lblDescrip.text = "Risk Warning: It is possible that some companies may lack or have no data, or may delay the release of data. Please be aware of this.".localizeString()
        lblQuestion.text = "What you can explore after buy?".localizeString()
        lblMainBuyer.text = "Buyer:"
        lblSearchListTitle.text = "Search list".localizeString()
        lblSearchListDescrip.text = "Search for buyers by product name or hscode, return to the buyer\'s company name, total transaction quantity, traded products, hscode (this field is empty), number of transactions that match the keyword, and total number of companies.".localizeString()
        
        lblBuyerDetail.text = "Buyer Details:".localizeString()
        lblTransOverview.text = "Transaction Overview".localizeString()
        lblTransDescrip.text = "Transaction overview of the buyer within the past four years.".localizeString()
        lblTradePartner.text = "Trade partner".localizeString()
        lblTradePartnerDescrip.text = "The buyer\'s trade partner.".localizeString()
        lblHSCodeTitle.text = "HSCODE".localizeString()
        lblHSCodeDescrip.text = "The hscode of the products purchased by the buyer.".localizeString()
        lblTradingAreaTitle.text = "Trading Area".localizeString()
        lblTradingAreaDescrip.text = "The trading area of the buyer.".localizeString()
        lblStats.text = "Port Statistics".localizeString()
        lblPortDescrip.text = "The buyer\'s trade port.".localizeString()
        
        lblMainSupplier.text = "Supplier".localizeString()
        lblSSearchList.text = "Search list".localizeString()
        lblSDescrip.text = "Search for buyers by product name or hscode, return to the buyer\'s company name, total transaction quantity, traded products, hscode (this field is empty), number of transactions that match the keyword, and total number of companies.".localizeString()
        
        lblSupplierDetail.text = "Supplier Details:".localizeString()
        lblSTransOverview.text = "Transaction Overview".localizeString()
        lblSTransDescrip.text = "Transaction overview of the supplier within the past four years.".localizeString()
        lblSTransPartner.text = "Trade partner".localizeString()
        lblSTransPartnerDescrip.text = "The supplier\'s trade partner.".localizeString()
        lblSHSCode.text = "HSCODE".localizeString()
        lblSHSCodeDescrip.text = "The hscode of the products purchased by the supplier.".localizeString()
        lblSTradingArea.text = "Trading Area".localizeString()
        lblSTradingAreaDescrip.text = "The trading area of the supplier.".localizeString()
        lblSPortStats.text = "Port Statistics".localizeString()
        lblSPortDescrip.text = "The supplier\'s trade port.".localizeString()
        lblContactInfo.text = "Contact Information:".localizeString()
        lblBuyerSupplier.text = "Buyer/Supplier".localizeString()
        lblBuyerSupplierDescrip.text = "Return to the publicly available contact information of the enterprise, such as official website, email, mobile phone, etc.".localizeString()
        
        lblCustomData.text = "Customs Data:".localizeString()
        lblCustomDataSearchList.text = "Customs data search list".localizeString()
        lblCustomDataSearchListDescrip.text = "Searching by using data type, product name/hscode and other parameters, return to customs data list".localizeString()
        lblBuyerTradeData.text = "Buyer\'s trade data".localizeString()
        lblBuyerTradeDescrip.text = "The trade details of the designated buyer, including trading partners, HS codes, trade regions and port statistics.".localizeString()
        lblSupplierTradeData.text = "Supplier\'s trade data".localizeString()
        lblSupplierTradeDescrip.text = "The trade details of the designated supplier, including trading partners , HS codes, trade regions and port statistics.".localizeString()
    }
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "PaymentTableViewCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "PaymentTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func buyTappedButton(_ sender: UIButton) {
        // Placeholder for buy logic
        if let payment = selectedPayment {
            showPaymentOptions(price: payment.price, credits: payment.credits) { [weak self] status in
                if status {
                    self?.dismiss(animated: false) {
                        YCTHud.sharedInstance().showSuccessHud("success".localizeString())
                    }
                } else {
                    self?.dismiss(animated: false) {
                        YCTHud.sharedInstance().showSuccessHud("failure".localizeString())
                    }
                }
            }
        } else {
            showAlert(message: "Please select an item.".localizeString())
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell

        // Update cell appearance based on selection
        let obj = paymentData[indexPath.row]
        cell.configureCell(obj: obj)
        
        if indexPath.row == selectedIndex {
            cell.imgCircule.backgroundColor = UIColor.hexStringToUIColor(hex: "022EA9") // Selected state
        } else {
            cell.imgCircule.backgroundColor = .clear // Default state
        }

        cell.imgCircule.layer.cornerRadius = cell.imgCircule.frame.size.width / 2
        cell.imgCircule.clipsToBounds = true
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row // Update the selected row
        selectedPayment = paymentData[indexPath.row]
        tableView.reloadData() // Reload the table to apply changes
    }
}
