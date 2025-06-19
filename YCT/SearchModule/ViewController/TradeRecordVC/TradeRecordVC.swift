//
//  TradeRecordVC.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/10/24.
//

import UIKit

class TradeRecordVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // Import Data 0
    @IBOutlet weak var lblImportData: UILabel!
    @IBOutlet weak var viewImportData: UIView!
    
    // Export Data 1
    @IBOutlet weak var lblExportData: UILabel!
    @IBOutlet weak var viewExportData: UIView! // #022EA9
    
    //MARK: - Variables
    var isLoadingData: Bool = true
    var noMoreData: Bool = false
    var selectedImportExportType: ImportExportType = .Import
    var companyListVM: CompanyListViewModel = CompanyListViewModel()
    var paramModel: CompanyListParamsModel?
    
    var importData: CompanyListModel?
    var pageImportData: Int = 1

    var exportData: CompanyListModel?
    var pageExportData: Int = 1
    var pageCount: Int = 10
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLanguage()
        companyListVM.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureImportExportView()
    }
    
    //MARK: - Custom Functions
    func configureLanguage() {
        lblHeaderTitle.text = "Total".localizeString() + " -- -- " + "trade records".localizeString()
        lblNoDataFound.text = "No Data Found".localizeString()
    }
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "TradeRecordTableViewCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "TradeRecordTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func callCompanyListAPI() {
        showLoader()
        let page = paramModel?.dataType == 0 ? pageImportData : pageExportData
        companyListVM.companyListAPI(obj: paramModel ?? CompanyListParamsModel(dataType: paramModel?.dataType ?? 0, page: page, pageCount: pageCount), isFromSearch: false)
    }
    
    func configureImportExportView() {
        switch paramModel?.dataType {
        case 0:
            lblImportData.textColor = UIColor.white
            viewImportData.backgroundColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            
            viewExportData.backgroundColor = UIColor.clear
            lblExportData.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            viewExportData.borderWidth = 1
            viewExportData.borderColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            let totalText = NSAttributedString(string: "Total".localizeString(), attributes: [.foregroundColor: UIColor.black])
            let nums = " \(importData?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
            let tradeRecordsText = NSAttributedString(string: "trade records".localizeString(), attributes: [.foregroundColor: UIColor.black])
            let title = NSMutableAttributedString()
            title.append(totalText)
            title.append(nums)
            title.append(tradeRecordsText)
            lblHeaderTitle.attributedText = title
            tableView.reloadData()
        case 1:
            lblImportData.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            viewImportData.backgroundColor = UIColor.clear
            viewImportData.borderWidth = 1
            viewImportData.borderColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            
            lblExportData.textColor = UIColor.white
            viewExportData.backgroundColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            
            let totalText = NSAttributedString(string: "Total".localizeString(), attributes: [.foregroundColor: UIColor.black])
            let nums = " \(exportData?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
            let tradeRecordsText = NSAttributedString(string: "trade records".localizeString(), attributes: [.foregroundColor: UIColor.black])
            let title = NSMutableAttributedString()
            title.append(totalText)
            title.append(nums)
            title.append(tradeRecordsText)
            lblHeaderTitle.attributedText = title
            tableView.reloadData()
        default:
            break
        }
        if importData == nil || exportData == nil {
            callCompanyListAPI()
        }
    }
    
    // MARK: - Custom Actions
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func importDataTapped(_ sender: UIButton) {
        paramModel?.dataType = 0
        configureImportExportView()
    }
    
    @IBAction func exportDataTapped(_ sender: UIButton) {
        paramModel?.dataType = 1
        configureImportExportView()
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension TradeRecordVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paramModel?.dataType == 0 {
            lblNoDataFound.isHidden = !(importData?.lists?.isEmpty ?? true)
            return importData?.lists?.count ?? 0

        } else {
            lblNoDataFound.isHidden = !(exportData?.lists?.isEmpty ?? true)
            return exportData?.lists?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradeRecordTableViewCell", for: indexPath) as! TradeRecordTableViewCell
        
        cell.vc = self
        cell.importExportType = selectedImportExportType
        if paramModel?.dataType == 0 {
            let obj = importData?.lists?[indexPath.row]
            cell.configureTradeRecordCell(obj: obj)
        } else {
            let obj = exportData?.lists?[indexPath.row]
            cell.configureTradeRecordCell(obj: obj)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 194
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY >= (contentHeight - scrollViewHeight) {
            if !noMoreData && !isLoadingData {
                
                print("Loading more data...")
                isLoadingData = true
                showLoader()
                callCompanyListAPI()
            } else {
                print("No more data or still loading.")
            }
        }
    }
}

//MARK: - CompanyListViewModelDelegate
extension TradeRecordVC: CompanyListViewModelDelegate {
    func didReceiveProductResponse(response: CompanyListModel?, error: String?) {
        self.hideLoader()
        isLoadingData = false
        
        if response == nil && error == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                
                if (response?.lists?.count ?? 0) < pageCount {
                    self.noMoreData = true
                } else {
                    self.noMoreData = false
                }
                
                if paramModel?.dataType == 0 {
                    if pageImportData == 1 {
                        importData?.lists?.removeAll()
                        importData = response
                        pageImportData += 1
                    } else {
                        importData?.lists?.append(contentsOf: response?.lists ?? [])
                        pageImportData += 1
                    }
                    let totalText = NSAttributedString(string: "Total".localizeString(), attributes: [.foregroundColor: UIColor.black])
                    let nums = " \(importData?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
                    let tradeRecordsText = NSAttributedString(string: "trade records".localizeString(), attributes: [.foregroundColor: UIColor.black])
                    let title = NSMutableAttributedString()
                    title.append(totalText)
                    title.append(nums)
                    title.append(tradeRecordsText)
                    lblHeaderTitle.attributedText = title
                    tableView.reloadData()
                } else {
                    if pageExportData == 1 {
                        exportData?.lists?.removeAll()
                        exportData = response
                        pageExportData += 1
                    } else {
                        exportData?.lists?.append(contentsOf: response?.lists ?? [])
                        pageExportData += 1
                    }
                    
                    let totalText = NSAttributedString(string: "Total".localizeString(), attributes: [.foregroundColor: UIColor.black])
                    let nums = " \(exportData?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
                    let tradeRecordsText = NSAttributedString(string: "trade records".localizeString(), attributes: [.foregroundColor: UIColor.black])
                    let title = NSMutableAttributedString()
                    title.append(totalText)
                    title.append(nums)
                    title.append(tradeRecordsText)
                    lblHeaderTitle.attributedText = title
                    tableView.reloadData()
                }
                
                
            } else {
                showAlert(message: error ?? "")
            }
            
        }
        
    }
}
