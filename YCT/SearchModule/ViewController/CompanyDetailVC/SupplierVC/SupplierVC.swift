//
//  SupplierVC.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/18/24.
//

import UIKit

class SupplierVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    //MARK: - Variables
    var supplierData: TradePartnerModel?
    var dataType: Int = 0
    var companyName: String = ""
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        lblNoDataFound.text = "No Data Found".localizeString()
    }
    
    //MARK: - Custom Functions
    func configureTableView() {
        let tableCellNib = UINib(nibName: "TransactionsRecordsCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "TransactionsRecordsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
    
    //MARK: - Custom ACTIONS
    
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension SupplierVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if supplierData?.data?.isEmpty ?? true {
            lblNoDataFound.isHidden = false
        } else {
            lblNoDataFound.isHidden = true
        }
        return supplierData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsRecordsCell", for: indexPath) as! TransactionsRecordsCell
        cell.vc = self
        cell.dataType = dataType
        cell.companyName = companyName
        cell.configureSupplierCell(obj: supplierData, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 194
    }
    
}
