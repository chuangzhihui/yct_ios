//
//  TransactionsRecordsVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 18/11/2024.
//

import UIKit
//

class TransactionsRecordsVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTransactionYear: UILabel!
    @IBOutlet weak var lblNoDataFOund: UILabel!
    
    // MARK: - Variable & Constants
    var dataType: Int = 0
    var companyName: String = ""
    var currentYear: Int = 0
    var importExportType: ImportExportType = .Import
    var companyListVM: CompanyListViewModel = CompanyListViewModel()
    var transactionRecordsData: CompanyListModel?
    var currentPage: Int = 1
    var pageCount: Int = 10
    var isLoadingData: Bool = true
    var noMoreData: Bool = false
    var didChangeYearCallBack: ((Int) -> ())?
    var scrollCallBack: (() -> ())?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let totalText = NSAttributedString(string: "Total".localizeString(), attributes: [.foregroundColor: UIColor.black])
        let nums = " \(transactionRecordsData?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
        let tradeRecordsText = NSAttributedString(string: "transaction recods".localizeString(), attributes: [.foregroundColor: UIColor.black])
        let title = NSMutableAttributedString()
        title.append(totalText)
        title.append(nums)
        title.append(tradeRecordsText)
        
        lblTitle.attributedText = title
        lblTransactionYear.text = "Transaction Year".localizeString() + " \(currentYear)"
        lblNoDataFOund.text = "No Data Found".localizeString()
        setupTapGesture()
        configureTableView()
    }
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "TransactionsRecordsCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "TransactionsRecordsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
    
    func getCurrentYear() -> Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return currentYear
    }

    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // Start Time and End Time
    func getStartAndEndTime(of year: Int) -> (startTime: Int, endTime: Int)? {
        let calendar = Calendar.current
        let components = DateComponents(year: year)
        
        guard
            let startDate = calendar.date(from: components),
            let endDate = calendar.date(from: DateComponents(year: year + 1))?.addingTimeInterval(-1)
        else {
            return nil
        }
        return (Int(startDate.timeIntervalSince1970), Int(endDate.timeIntervalSince1970))
    }
    
    func moveToYearVC() {
        let yearSelectionVC = UIStoryboard(name: "FilterViews", bundle: nil).instantiateViewController(withIdentifier: "YearSelectionVC") as! YearSelectionVC

        yearSelectionVC.modalPresentationStyle = .overFullScreen
        yearSelectionVC.currentYear = currentYear
        // Call Back
        yearSelectionVC.callBack = { [weak self] intYear in
            self?.lblTransactionYear.text = "Transaction Year".localizeString() + "\(intYear)"
            
            self?.didChangeYearCallBack?(intYear)
        }
        present(yearSelectionVC, animated: false)
    }

    // MARK: - Custom Action
    @IBAction func dateTapped(_ sender: UIButton) {
        moveToYearVC()
    }
}


// MARK: - UITableViewDelegate UITableViewDataSource
extension TransactionsRecordsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactionRecordsData?.lists?.isEmpty ?? true {
            lblNoDataFOund.isHidden = false
        } else {
            lblNoDataFOund.isHidden = true
        }
        return transactionRecordsData?.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsRecordsCell", for: indexPath) as! TransactionsRecordsCell
        
        cell.vc = self
        cell.dataType = dataType
        let obj = transactionRecordsData?.lists?[indexPath.row]
        cell.importExportType = importExportType
        cell.configureTransactionRecordsCell(obj: obj)
        
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
        let bottomInset = tableView.contentInset.bottom
        
        if offsetY >= (contentHeight - scrollViewHeight + bottomInset) {
            if !noMoreData && !isLoadingData {
                
                print("Loading more data...")
                isLoadingData = true
                scrollCallBack?()
            } else {
                print("No more data or still loading.")
            }
        }
    }
}



