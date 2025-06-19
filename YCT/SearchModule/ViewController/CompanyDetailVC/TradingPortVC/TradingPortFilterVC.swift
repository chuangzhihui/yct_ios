//
//  TradePortFilterVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 23/11/2024.
//

import UIKit

class TradingPortFilterVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblSearch: UILabel!
    
    // MARK: - Variable & Constants
    var tradeType: TradesType = .HSCode
    var filterDataCallBack: ((String) -> ())?
    var hsCodeSearchText: String = ""
    var tradeAreaSearchText: String = ""
    var tradingPortSearchText: String = ""
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switch tradeType {
        case .HSCode:
            txtField.text = hsCodeSearchText
        case .TradeArea:
            txtField.text = tradeAreaSearchText
        case .TradingPort:
            txtField.text = tradingPortSearchText
        }
        configureView()
    }
    
    // MARK: - Custom Functions
    func configureView() {
        lblSearch.text = "Search".localizeString()
        switch tradeType {
        case .HSCode:
            lblTitle.text = "HS Code".localizeString()
            txtField.placeholder = "Please enter hs code".localizeString()
            
        case .TradeArea:
            lblTitle.text = "Trade Area".localizeString()
            txtField.placeholder = "Please enter region name".localizeString()
            
        case .TradingPort:
            lblTitle.text = "Trading Ports".localizeString()
            txtField.placeholder = "Please enter port name".localizeString()
        }
    }
    
    // MARK: - Custom Actions
    @IBAction func crossTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        dismiss(animated: false) {
            let text = self.txtField.text ?? ""
            switch self.tradeType {
            case .HSCode:
                self.filterDataCallBack?(text)
            case .TradeArea:
                self.filterDataCallBack?(text)
            case .TradingPort:
                self.filterDataCallBack?(text)
            }
        }
    }
}
