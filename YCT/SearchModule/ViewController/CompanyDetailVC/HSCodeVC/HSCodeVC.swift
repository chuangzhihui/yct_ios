//
//  HSCodeVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 24/11/2024.
//

import UIKit

class HSCodeVC: UIViewController {

    @IBOutlet weak var hsCodeTableView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // MARK: - Variable & Constants
    var hsCodeData: HSCodeModel?
    var importExportType: ImportExportType = .Import
    var dataType: Int = 0
    var companyName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        lblNoDataFound.text = "No Data Found".localizeString()
    }
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "HSCodeTableCell", bundle: nil)
        hsCodeTableView.register(tableCellNib, forCellReuseIdentifier: "HSCodeTableCell")
        hsCodeTableView.delegate = self
        hsCodeTableView.dataSource = self
        hsCodeTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }

}

// MARK: - UITableViewDelegate UITableViewDataSource
extension HSCodeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hsCodeData?.data?.isEmpty ?? true {
            lblNoDataFound.isHidden = false
        } else {
            lblNoDataFound.isHidden = true
        }
        return hsCodeData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hsCodeTableView.dequeueReusableCell(withIdentifier: "HSCodeTableCell", for: indexPath) as! HSCodeTableCell
        
        cell.vc = self
        cell.dataType = dataType
        cell.companyName = companyName
        cell.selectedOverViewState = .HSCode
        cell.importExportType = importExportType
        cell.configureHSCodeCell(obj: hsCodeData, index: indexPath.row)
        
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


