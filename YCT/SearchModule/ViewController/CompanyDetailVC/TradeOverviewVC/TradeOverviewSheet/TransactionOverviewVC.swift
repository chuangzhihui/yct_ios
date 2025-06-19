//
//  TransactionOverviewVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 18/11/2024.
//

import UIKit

enum OverViewStates: String, CaseIterable {
    case TransactionOverview = "Transaction Overview"
    case TradeRecords = "Trade Records"
    case Supplier = "Supplier"
    case HSCode = "HS Code"
    case TradeArea = "Trade Area"
    case TradingPort = "Trading Port"
}

class TransactionOverviewVC: UIViewController {

    @IBOutlet weak var transactionTableView: UITableView!
    
    var dataType: Int = 0
    var dataArray = OverViewStates.allCases
    var selectedState: OverViewStates?
    var selectedStateTapped: ((OverViewStates?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    func configureTableView() {
        let cellNib = UINib(nibName: "TransactionOverviewCell", bundle: nil)
        transactionTableView.register(cellNib, forCellReuseIdentifier: "TransactionOverviewCell")
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TransactionOverviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "TransactionOverviewCell", for: indexPath) as! TransactionOverviewCell
        
        let currentState = dataArray[indexPath.row]
        cell.lblTitle.text = dataArray[indexPath.row].rawValue.getString(for: dataType).localizeString()
        
        // Change the color based on selected state
        if selectedState == currentState {
            cell.lblTitle.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
        } else {
            cell.lblTitle.textColor = .black
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentState = dataArray[indexPath.row]
        
        if selectedState == currentState {
            selectedState = nil
        } else {
            selectedState = currentState
        }
        
        transactionTableView.reloadData()
        dismiss(animated: true) { [weak self] in
            self?.selectedStateTapped?(currentState)
        }
    }
    
}
