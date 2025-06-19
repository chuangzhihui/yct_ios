//
//  TradeAreaVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 24/11/2024.
//

import UIKit

class TradeAreaVC: UIViewController {

    // MARK: - Variable & Constants
    @IBOutlet weak var tradeAreaTableView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // MARK: - Variable & Constants
    var tradeAreaData: TradeAreaModel?
    var dataType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        lblNoDataFound.text = "No Data Found".localizeString()

    }
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "HSCodeTableCell", bundle: nil)
        tradeAreaTableView.register(tableCellNib, forCellReuseIdentifier: "HSCodeTableCell")
        tradeAreaTableView.delegate = self
        tradeAreaTableView.dataSource = self
        tradeAreaTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension TradeAreaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tradeAreaData?.items?.isEmpty ?? true {
            lblNoDataFound.isHidden = false
        } else {
            lblNoDataFound.isHidden = true
        }
        return tradeAreaData?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tradeAreaTableView.dequeueReusableCell(withIdentifier: "HSCodeTableCell", for: indexPath) as! HSCodeTableCell
        
        cell.selectedOverViewState = .TradeArea
        cell.dataType = dataType
        cell.vc = self
        cell.configureTradeAreaCell(obj: tradeAreaData, index: indexPath.row)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 194
    }

}
