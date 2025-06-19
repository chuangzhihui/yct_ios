//
//  TradingPortVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 23/11/2024.
//

import UIKit

class TradingPortVC: UIViewController {
    
    @IBOutlet weak var tradingPortTableView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var tradePortData: TradePortModel?
    var dataType: Int = 0
    var companyName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoDataFound.text = "No Data Found".localizeString()

        configureTableView()
    }
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "HSCodeTableCell", bundle: nil)
        tradingPortTableView.register(tableCellNib, forCellReuseIdentifier: "HSCodeTableCell")
        tradingPortTableView.delegate = self
        tradingPortTableView.dataSource = self
        tradingPortTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
}
    // MARK: - UITableViewDelegate UITableViewDataSource
extension TradingPortVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tradePortData?.items?.isEmpty ?? true {
            lblNoDataFound.isHidden = false
        } else {
            lblNoDataFound.isHidden = true
        }
        return tradePortData?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tradingPortTableView.dequeueReusableCell(withIdentifier: "HSCodeTableCell", for: indexPath) as! HSCodeTableCell

        cell.dataType = dataType
        cell.companyName = companyName
        cell.selectedOverViewState = .TradingPort
        cell.vc = self
        cell.configureTradingPortCell(obj: tradePortData, index: indexPath.row)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 194
    }
}
