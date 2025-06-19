//
//  OverviewDetailVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 07/12/2024.
//

import UIKit

class OverviewDetailVC: UIViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var overViewDetailTableView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // MARK: - Variable & Constants
    var overViewState: OverViewStates? = .HSCode
    var selectedImportExportType: ImportExportType = .Import
    var companyListVM: CompanyListViewModel = CompanyListViewModel()
    var paramModel: CompanyListParamsModel?
    var isLoadingData: Bool = true
    var noMoreData: Bool = false
    var companyListData: CompanyListModel?
    var dataType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoDataFound.text = "No Data Found".localizeString()

        switch overViewState {
        case .HSCode:
            lblHeaderTitle.text = "HS Code Details".localizeString()
            
        case .Supplier:
            lblHeaderTitle.text = "Supplier Details".localizeString()
            
        case .TradeArea:
            lblHeaderTitle.text = "TradeArea Details".localizeString()
            
        case .TradingPort:
            lblHeaderTitle.text = "Trade Port Details".localizeString()
            
        default:
            lblHeaderTitle.text = "Details".localizeString()
        }
        companyListVM.delegate = self
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callCompanyListAPI()
    }
    
    func callCompanyListAPI() {
        self.showLoader()
        companyListVM.companyListAPI(obj: paramModel ?? CompanyListParamsModel(dataType: 0, page: 1, pageCount: 10))
    }
    
    func moveToFilterVC() {
        
    }
    
    func configureTableView() {
        let cellNib = UINib(nibName: "TradeRecordTableViewCell", bundle: nil)
        overViewDetailTableView.register(cellNib, forCellReuseIdentifier: "TradeRecordTableViewCell")
        overViewDetailTableView.delegate = self
        overViewDetailTableView.dataSource = self
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func filterTapped(_ sender: UIButton) {
        moveToFilterVC()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension OverviewDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblNoDataFound.isHidden = !(companyListData?.lists?.isEmpty ?? true)
        return companyListData?.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = overViewDetailTableView.dequeueReusableCell(withIdentifier: "TradeRecordTableViewCell", for: indexPath) as! TradeRecordTableViewCell
        
        cell.vc = self
        cell.dataType = dataType
        cell.importExportType = selectedImportExportType
        let obj = companyListData?.lists?[indexPath.row]
        
        switch overViewState {
        case .HSCode:
            cell.configureOverViewHSCell(obj: obj)
        case .Supplier:
            break
            
        case .TradeArea:
            cell.configureOverViewTradeAreaDetails(obj: obj)
            
        case .TradingPort:
            cell.configureOverViewTradePortDetails(obj: obj)
            
        default:
            break
        }
        
        cell.selectionStyle = .none
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


// MARK: - CompanyListViewModelDelegate
extension OverviewDetailVC: CompanyListViewModelDelegate {
    func didReceiveProductResponse(response: CompanyListModel?, error: String?) {
        self.hideLoader()
        isLoadingData = false
        
        if error == nil && response == nil {
            lblNoDataFound.isHidden = false
            moveToPaymentVC()
        } else {
            if error == nil {
                
                if (response?.lists?.count ?? 0) < paramModel?.pageCount {
                    self.noMoreData = true
                } else {
                    self.noMoreData = false
                }
                
                if (paramModel?.page ?? 1) == 1 {
                    companyListData?.lists?.removeAll()
                    companyListData = response
                    paramModel?.page += 1
                } else {
                    companyListData?.lists?.append(contentsOf: response?.lists ?? [])
                    paramModel?.page += 1
                }
                overViewDetailTableView.reloadData()
            } else {
                self.showAlert(message: error ?? "")
            }
            
        }
    }
}
