//
//  SupplierDetailVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 07/12/2024.
//

import UIKit
import DGCharts

class SupplierDetailVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tradeRecordTableView: UITableView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var lblLineChartTotalTransactions: UILabel!
    @IBOutlet weak var lblTotalProportion: UILabel!
    @IBOutlet weak var lblTradeRecord: UILabel!
    @IBOutlet weak var viewTradeRecord: UIView!
    @IBOutlet weak var viewTradeOverview: UIView!
    @IBOutlet weak var lblTradeOverView: UILabel!
    @IBOutlet weak var lblDetail1: UILabel!
    @IBOutlet weak var lblDetail2: UILabel!
    
    @IBOutlet weak var viewMainTradeRecord: UIView!
    @IBOutlet weak var viewMainTradeOverview: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // Charts Filter // #CCCCCC
    @IBOutlet weak var lblTransactionTimesFilter: UILabel! // #5F80F5
    @IBOutlet weak var viewTransactionTimes: UIView!
    
    @IBOutlet weak var lblNumOfTransactionsFilter: UILabel! // #80DFCC
    @IBOutlet weak var viewNumOfTransactions: UIView!
    
    @IBOutlet weak var lblTransactionWeightFilter: UILabel! // #5FC3FA
    @IBOutlet weak var viewTransactionWeight: UIView!
    
    //MARK: - Variables
    var importExportType: ImportExportType = .Import
    var dataType: Int = 0
    var companyName: String = ""
    var id: String = ""
    var partnerName: String = ""
    var isLoadingData = true
    var noMoreData: Bool = false
    var page: Int = 1
    var pageCount: Int = 10
    var companyListVM: CompanyListViewModel = CompanyListViewModel()
    var companyListData: CompanyListModel?
    var tradePartnerDetailData: TradePartnerDetailModel?
    var chartFilterType: ChartFilterType = .count
    var proportion: String = ""
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTotalProportion.text = proportion
        tradeRecordOverViewState()
        configureTableView()
        companyListVM.delegate = self
        configureChartsFilter()
        configureLanguage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callLineChartAPI()
    }
    
    //MARK: - Custom Functions
    func configureLanguage() {
        lblHeader.text = "Supplier Details".localizeString()
        lblTradeOverView.text = "Trade Overview".localizeString()
        lblTradeRecord.text = "Trade Records".localizeString()
        lblDetail1.text = "Number of transactions between the two parties".localizeString()
        lblDetail2.text = "The proportion of transactions between the two parties to the total number of transactions of the company".localizeString()
        lblTransactionTimesFilter.text = "Transaction Times".localizeString()
        lblNumOfTransactionsFilter.text = "Number of Transactions".localizeString()
        lblTransactionWeightFilter.text = "Transaction Weight".localizeString()
    }
    
    func callLineChartAPI() {
        showLoader()
        let params: [String : Any] = [
            "dataType": dataType,
            "name": companyName,
            "id": id,
            "page": page,
            "pageCount": 5,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        companyListVM.supplierOverViewDetailAPI(parmas: params)
    }
    
    func callCompanyListAPI() {
        showLoader()
        var obj = CompanyListParamsModel(dataType: dataType, page: page, pageCount: pageCount)
        if dataType == 0 {
            obj.buyer = companyName
            obj.supplier = partnerName
        } else {
            obj.supplier = companyName
            obj.buyer = partnerName
        }
        companyListVM.companyListAPI(obj: obj)
    }
    
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "TransactionsRecordsCell", bundle: nil)
        tradeRecordTableView.register(tableCellNib, forCellReuseIdentifier: "TransactionsRecordsCell")
        tradeRecordTableView.delegate = self
        tradeRecordTableView.dataSource = self
    }
    
    //MARK: - State change for TradeOverView
    func tradeRecordOverViewState() {
        viewMainTradeRecord.isHidden = true
        viewMainTradeOverview.isHidden = false
        viewTradeOverview.backgroundColor = UIColor(hexString: "#022EA9")
        lblTradeOverView.textColor = UIColor(hexString: "#FFFFFF")
        viewTradeRecord.backgroundColor = UIColor(hexString: "#FFFFFF")
        viewTradeRecord.borderColor = UIColor(hexString: "#022EA9")
        viewTradeRecord.borderWidth = 1
        lblTradeRecord.textColor = UIColor(hexString: "#022EA9")
        let totalText = NSAttributedString(string: "Trade Records".localizeString(), attributes: [.foregroundColor: UIColor.black])
        let nums = " \(companyListData?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
        let tradeRecordsText = NSAttributedString(string: "trade records between the two parties".localizeString(), attributes: [.foregroundColor: UIColor.black])
        let title = NSMutableAttributedString()
        title.append(totalText)
        title.append(nums)
        title.append(tradeRecordsText)
        lblTitle.attributedText = title
    }
    //MARK: - State change for TradeRecoreView
    func tradeRecordViewState() {
        viewMainTradeRecord.isHidden = false
        viewMainTradeOverview.isHidden = true
        viewTradeRecord.backgroundColor = UIColor(hexString: "#022EA9")
        lblTradeRecord.textColor = UIColor(hexString: "#FFFFFF")
        viewTradeOverview.backgroundColor = UIColor(hexString: "#FFFFFF")
        viewTradeOverview.borderColor = UIColor(hexString: "#022EA9")
        viewTradeOverview.borderWidth = 1
        lblTradeOverView.textColor = UIColor(hexString: "#022EA9")
        tradeRecordTableView.reloadData()
        let totalText = NSAttributedString(string: "Trade Records".localizeString(), attributes: [.foregroundColor: UIColor.black])
        let nums = " \(companyListData?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
        let tradeRecordsText = NSAttributedString(string: "trade records between the two parties".localizeString(), attributes: [.foregroundColor: UIColor.black])
        let title = NSMutableAttributedString()
        title.append(totalText)
        title.append(nums)
        title.append(tradeRecordsText)
        lblTitle.attributedText = title
    }
    
    private func configureChartsFilter() {
        switch chartFilterType {
        case .count:
            lblTransactionTimesFilter.textColor = UIColor.hexStringToUIColor(hex: "#5F80F5")
            viewTransactionTimes.backgroundColor = UIColor.hexStringToUIColor(hex: "#5F80F5")
            
            lblNumOfTransactionsFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewNumOfTransactions.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblTransactionWeightFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionWeight.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
        case .number:
            lblTransactionTimesFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionTimes.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblNumOfTransactionsFilter.textColor = UIColor.hexStringToUIColor(hex: "#80DFCC")
            viewNumOfTransactions.backgroundColor = UIColor.hexStringToUIColor(hex: "#80DFCC")
            
            lblTransactionWeightFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionWeight.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
        case .weight:
            lblTransactionTimesFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionTimes.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblNumOfTransactionsFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewNumOfTransactions.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblTransactionWeightFilter.textColor = UIColor.hexStringToUIColor(hex: "#5FC3FA")
            viewTransactionWeight.backgroundColor = UIColor.hexStringToUIColor(hex: "#5FC3FA")
        }
    }
    
    private func displayGraph() {
        guard let obj = tradePartnerDetailData,
              let records = obj.records, !records.isEmpty else { return }
        
        // Prepare chart data entries and x-axis labels
        let reversedRecords = records.reversed()
        let maxGraph = min(12, reversedRecords.count)
        let startIndex = max(0, reversedRecords.count - maxGraph)
        var entries: [ChartDataEntry] = []
        var xAxisLabels: [String] = []
        
        // Loop through filtered records
        for (index, record) in reversedRecords.enumerated() {
            let value: Float = {
                switch chartFilterType {
                case .count:
                    return Float(record.count ?? 0)
                case .number:
                    return Float((record.quantity ?? 0))
                case .weight:
                    return Float(record.weight ?? 0)
                }
            }()
            
            entries.append(ChartDataEntry(x: Double(index), y: Double(value)))
            xAxisLabels.append(record.date ?? "")
        }
        
        // Configure Line Chart Data Set
        let lineDataSet = LineChartDataSet(entries: entries, label: "")
        let color: UIColor = {
            switch chartFilterType {
            case .count:
                return UIColor.hexStringToUIColor(hex: "#5F80F5")
            case .number:
                return UIColor.hexStringToUIColor(hex: "#80DFCC")
            case .weight:
                return UIColor.hexStringToUIColor(hex: "#5FC3FA")
            }
        }()
        
        lineDataSet.colors = [color]
        lineDataSet.lineWidth = 2.0
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawValuesEnabled = false
        
        // Assign Data to Line Chart
        let lineData = LineChartData(dataSet: lineDataSet)
        lineChartView.data = lineData
        
        // Beautify Chart
        beautifyChart(xMax: lineData.xMax, xAxisLabels: xAxisLabels)
    }


    private func beautifyChart(xMax: Double, xAxisLabels: [String]) {
        // Disable right axis
        lineChartView.rightAxis.enabled = false
        
        // Customize left axis
        let leftAxis = lineChartView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.axisMaximum = max(220.0, leftAxis.axisMaximum)
        
        let maxLeftYValue = lineChartView.lineData?.dataSets.max(by: { $0.yMax < $1.yMax })?.yMax ?? 0.0
        leftAxis.axisMaximum = maxLeftYValue * 1.3

        // Customize x-axis
        let xAxis = lineChartView.xAxis
        xAxis.axisMaximum = xMax
        xAxis.drawAxisLineEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        xAxis.granularity = 1.0
        xAxis.drawGridLinesEnabled = false
        
        // Chart settings
        lineChartView.chartDescription.enabled = false
        lineChartView.legend.enabled = false
        
        // Animate and refresh
        lineChartView.animate(xAxisDuration: 0.5, easingOption: .easeInCirc)
        lineChartView.notifyDataSetChanged()
    }
    
    //MARK: - Custom Actions
    @IBAction func tradeRecordOverview(_ sender: UIButton) {
        tradeRecordOverViewState()
        
    }
    
    @IBAction func tradeRecordTapped(_ sender: UIButton) {
        tradeRecordViewState()
        if companyListData == nil {
            callCompanyListAPI()
        }
    }
    
    @IBAction func backButtonTapeed(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func filterTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func transactionsTimeTapped(_ sender: UIButton) {
        chartFilterType = .count
        configureChartsFilter()
        displayGraph()
    }
    
    @IBAction func transactionNumTapped(_ sender: UIButton) {
        chartFilterType = .number
        configureChartsFilter()
        displayGraph()
    }
    
    @IBAction func transactionWeightTapped(_ sender: UIButton) {
        chartFilterType = .weight
        configureChartsFilter()
        displayGraph()
    }
}
// MARK: - UITableViewDelegate UITableViewDataSource
extension SupplierDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyListData?.lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsRecordsCell", for: indexPath) as! TransactionsRecordsCell
        
        cell.vc = self
        cell.dataType = dataType
        cell.importExportType = importExportType
        let list = companyListData?.lists?[indexPath.row]
        cell.configureTransactionRecordsCell(obj: list)

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



//MARK: - CompanyListViewModelDelegate
extension SupplierDetailVC: CompanyListViewModelDelegate {
    func didReceiveProductResponse(response: CompanyListModel?, error: String?) {
        self.hideLoader()
        isLoadingData = false
        
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                if (response?.lists?.count ?? 0) < pageCount {
                    self.noMoreData = true
                } else {
                    self.noMoreData = false
                }
                
                if page == 1 {
                    companyListData?.lists?.removeAll()
                    companyListData = response
                    page += 1
                } else {
                    companyListData?.lists?.append(contentsOf: response?.lists ?? [])
                    page += 1
                }
                
                let totalText = NSAttributedString(string: "Trade Records".localizeString(), attributes: [.foregroundColor: UIColor.black])
                let nums = " \(response?.total ?? 0) ".colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
                let tradeRecordsText = NSAttributedString(string: "trade records between the two parties".localizeString(), attributes: [.foregroundColor: UIColor.black])
                let title = NSMutableAttributedString()
                title.append(totalText)
                title.append(nums)
                title.append(tradeRecordsText)
                
                lblTitle.attributedText = title
                tradeRecordTableView.reloadData()
            } else {
                showAlert(message: error ?? "")
            }
            
        }
        
    }
    
    func didReceiveTradePartnerOverviewDetail(response: TradePartnerDetailModel?, error: String?) {
        self.hideLoader()
        
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                tradePartnerDetailData = response
                displayGraph()
                lblLineChartTotalTransactions.text = (response?.data?.total ?? "") + "items"
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
}
