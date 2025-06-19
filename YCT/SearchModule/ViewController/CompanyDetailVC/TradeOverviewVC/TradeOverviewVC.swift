//
//  TradeOverviewVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 18/11/2024.
//

import UIKit
import DGCharts

enum GraphType {
    case Monthly
    case Yearly
}

enum ChartFilterType {
    case count
    case number
    case weight
}

class TradeOverviewVC: UIViewController {
    
    @IBOutlet weak var viewMonthly: UIView!
    @IBOutlet weak var viewYearly: UIView!
    @IBOutlet weak var lblOverView: UILabel!
    @IBOutlet weak var lblNumOfTransactions: UILabel!
    @IBOutlet weak var lblTransactionQuantity: UILabel!
    @IBOutlet weak var lblTransactionWeight: UILabel!
    @IBOutlet weak var lblDateRange: UILabel!
    
    // Transaction Overview
    @IBOutlet weak var viewTransactionOverview: UIView!
    @IBOutlet weak var lblTONumOfTransTitle: UILabel!
    @IBOutlet weak var lblTOTransQuantity: UILabel!
    @IBOutlet weak var lblTOTransWeight: UILabel!
    @IBOutlet weak var lblTOMonthly: UILabel!
    @IBOutlet weak var lblTOYearly: UILabel!
    
    // Supplier View
    @IBOutlet weak var lblTotalDataCount: UILabel! // Total Count
    @IBOutlet weak var lblCurrentStateCount: UILabel! // Selected Count
    
    // Trade Area View
    @IBOutlet weak var viewTradeArea: UIView!
    @IBOutlet weak var tradeAreaCollectionView: UICollectionView!
    @IBOutlet weak var heightTradeAreaCollectionView: NSLayoutConstraint!
    @IBOutlet weak var lblTradeAreaViewAllData: UILabel!
    
    // Trade Records View
    @IBOutlet weak var viewTradeRecords: UIView!
    @IBOutlet weak var tradeRecordsNumOfTransactions: UILabel!
    @IBOutlet weak var tradeRecordsLatestTradingTime: UILabel!
    @IBOutlet weak var lblTradeRecordsCurrentIndex: UILabel!
    @IBOutlet weak var lblTradeRecordsMaxIndex: UILabel!
    @IBOutlet weak var lblTradeRecordTotalNumOfTrans: UILabel!
    @IBOutlet weak var lblTradeRecordTradingTimes: UILabel!
    @IBOutlet weak var lblTradeRecordDate: UILabel!
    @IBOutlet weak var lblTradeRecordBillNum: UILabel!
    @IBOutlet weak var lblTradeRecordsSupplyingCountry: UILabel!
    @IBOutlet weak var lblTradeRecordsPurchasingCountry: UILabel!
    @IBOutlet weak var lblTradeRecordsHSCode: UILabel!
    @IBOutlet weak var lblTradeRecordsQuantity: UILabel!
    @IBOutlet weak var lblTradeRecordsWeight: UILabel!
    @IBOutlet weak var lblTradeRecordsAmount: UILabel!
    @IBOutlet weak var lblTradeRecordsTransportMode: UILabel!
    @IBOutlet weak var lblTradeRecordsExportPort: UILabel!
    @IBOutlet weak var lblTradeRecordsPortOfEntry: UILabel!
    @IBOutlet weak var lblTradeRecordsBuyer: UILabel!
    @IBOutlet weak var lblTradeRecordsSupplier: UILabel!
    @IBOutlet weak var lblTradingProducts: UILabel!
    @IBOutlet weak var lblTRNumOfTransactions: UILabel!
    @IBOutlet weak var lblTRLatestTradeTime: UILabel!
    @IBOutlet weak var lblTRBillLandNum: UILabel!
    @IBOutlet weak var lblTRSupplyingCompany: UILabel!
    @IBOutlet weak var lblTRPurchasingCountry: UILabel!
    @IBOutlet weak var lblTRHSCode: UILabel!
    @IBOutlet weak var lblTRQuantity: UILabel!
    @IBOutlet weak var lblTRWeight: UILabel!
    @IBOutlet weak var lblTRAmount: UILabel!
    @IBOutlet weak var lblTRModeTransport: UILabel!
    @IBOutlet weak var lblTRExportPort: UILabel!
    @IBOutlet weak var lblTRPortOfEntry: UILabel!
    @IBOutlet weak var lblTRBuyer: UILabel!
    @IBOutlet weak var lblTRSupplier: UILabel!
    @IBOutlet weak var lblTRTradingProducts: UILabel!
    @IBOutlet weak var lblTRViewAllData: UILabel!
    
    
    @IBOutlet weak var lblSupplierDate: UILabel!
    @IBOutlet weak var viewSupplier: UIView!
    @IBOutlet weak var pieChartSupplier: PieChartView!
    
    @IBOutlet weak var lblTitleNumOfTransaction: UILabel! // Bottom Leading Title
    @IBOutlet weak var lblTransactionCount: UILabel! // Bottom Leading Count
    
    @IBOutlet weak var lblTitleHSCode: UILabel! // Top Leading Title
    @IBOutlet weak var lblHSCodeData: UILabel! // To Leading Data
    
    @IBOutlet weak var lblProportion: UILabel! // Proportion Count
    
    @IBOutlet weak var lblTotalCountTitle: UILabel!
    @IBOutlet weak var lblTotalData: UILabel!
    
    @IBOutlet weak var viewCombinedChart: CombinedChartView!
    @IBOutlet weak var lblSupplierAllDataTitle: UILabel!
    
    // Charts Filter // #CCCCCC
    @IBOutlet weak var lblTransactionTimesFilter: UILabel! // #596FC0
    @IBOutlet weak var viewTransactionTimes: UIView!
    
    @IBOutlet weak var lblNumOfTransactionsFilter: UILabel! // #9ECA7E
    @IBOutlet weak var viewNumOfTransactions: UIView!
    
    @IBOutlet weak var lblTransactionWeightFilter: UILabel! // #5350BE
    @IBOutlet weak var viewTransactionWeight: UIView!
    
    // MARK: - Variable & Constants
    
    var importExportType: ImportExportType = .Import
    var buyerSupplierDataType: Int = 0
    var companyName: String = ""
    
    var companyTradeCountDetailVM: CompanyTradeCountDetailViewModel = CompanyTradeCountDetailViewModel()
    var graphType: GraphType = .Monthly
    var selectedOverViewState: OverViewStates? = .TransactionOverview
    var selectedOverViewStateUpdateCallBack: ((OverViewStates?) -> ())?
    var chartFilterType: ChartFilterType = .count
    
    var totalCountIndex: Int = 0
    var currentIndex: Int = 0
    
    // All Views Data
    var tradeCountData: TradeCountModel? // TransactionOverview Data
    
    var tradeRecordsData: TradeListModel? // Trade Records Data
    var tradeRecordsUpdatedCallBack: ((TradeListModel?) -> ())?
    
    var hsCodeData: HSCodeModel?         // HSCode Data
    var hsCodeUpdatedCallBack: ((HSCodeModel?) -> ())?
    
    var supplierData: TradePartnerModel? // Supplier Data
    var supplierUpdatedCallBack: ((TradePartnerModel?) -> ())?
    
    var tradeAreaData: TradeAreaModel?   // Trade Area Data
    var tradeAreaUpdatedCallBack: ((TradeAreaModel?) -> ())?
    
    var tradePortData: TradePortModel?   // Trade Port Data
    var tradePortUpdatedCallBack: ((TradePortModel?) -> ())?
    
    // View All Data Tapped Call Back
    var viewAllDataTappedCallBack: ((OverViewStates?) -> ())?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        companyTradeCountDetailVM.delegate = self
        configureChartsFilter()
        configureMonthlyYearly()
        let transactions = calculateTotals()
        lblNumOfTransactions.text = "\(transactions.totalCount)"
        lblTransactionQuantity.text = "\(transactions.totalQuantity)"
        lblTransactionWeight.text = "\(transactions.totalWeight)"
        displayDateRange()
        updateViewState(state: selectedOverViewState ?? .TransactionOverview)
        configureCollectionView()
        configureLanguage()
    }
    
    // MARK: - Custom Functions
    func configureLanguage() {
        lblTONumOfTransTitle.text = "Number of Transactions".localizeString()
        lblTOTransQuantity.text = "Transactions Quantity".localizeString()
        lblTOTransWeight.text = "Transaction Weight".localizeString()
        lblTransactionTimesFilter.text = "Transaction Times".localizeString()
        lblNumOfTransactionsFilter.text = "Number of Transactions".localizeString()
        lblTransactionWeightFilter.text = "Transaction Weight".localizeString()
        lblTOMonthly.text = "Monthly".localizeString()
        lblTOYearly.text = "Yearly".localizeString()
        
        lblTRNumOfTransactions.text = "Total number of transactions".localizeString()
        lblTRLatestTradeTime.text = "Latest trading time".localizeString()
        lblTRBillLandNum.text = "Bill of Landing Number".localizeString()
        lblTRSupplyingCompany.text = "Supplying Country".localizeString()
        lblTRPurchasingCountry.text = "Purchasing Country".localizeString()
        lblTRHSCode.text = "HS Code".localizeString()
        lblTRQuantity.text = "Quantity".localizeString()
        lblTRWeight.text = "Weight".localizeString()
        lblTRAmount.text = "Amount".localizeString()
        lblTRModeTransport.text = "Mode of transport".localizeString()
        lblTRExportPort.text = "Export Port".localizeString()
        lblTRPortOfEntry.text = "Port of entry".localizeString()
        lblTRBuyer.text = "Buyer".localizeString()
        lblTRSupplier.text = "Supplier".localizeString()
        lblTRTradingProducts.text = "Trading Products".localizeString()
        lblTRViewAllData.text = "View All Data".localizeString()
        lblSupplierAllDataTitle.text = "View All Data".localizeString()
        lblTradeAreaViewAllData.text = "View All Data".localizeString()
    }
    
    func configureCollectionView() {
        let tradeAreaCollectionViewCellNib = UINib(nibName: "TradeAreaCollectionViewCell", bundle: nil)
        tradeAreaCollectionView.register(tradeAreaCollectionViewCellNib, forCellWithReuseIdentifier: "TradeAreaCollectionViewCell")
        tradeAreaCollectionView.delegate = self
        tradeAreaCollectionView.dataSource = self
    }
    
    func configureMonthlyYearly() {
        switch graphType {
        case .Monthly:
            viewMonthly.backgroundColor = UIColor.hexStringToUIColor(hex: "#E4E8FB")
            viewMonthly.borderColor = UIColor.clear
            
            viewYearly.backgroundColor = UIColor.clear
            viewYearly.borderColor = UIColor.hexStringToUIColor(hex: "#E4E8FB")
            viewYearly.borderWidth = 1
            displayMonthlyGraph()
            
        case .Yearly:
            viewMonthly.backgroundColor = UIColor.clear
            viewMonthly.borderColor = UIColor.hexStringToUIColor(hex: "#E4E8FB")
            viewMonthly.borderWidth = 1
            
            viewYearly.backgroundColor = UIColor.hexStringToUIColor(hex: "#E4E8FB")
            viewYearly.borderColor = UIColor.clear
            displayYearlyGraph()
        }
    }
    
    private func calculateTotals() -> (totalQuantity: Int, totalCount: Int, totalWeight: Int) {
        var totalQuantity: Int = 0
        var totalCount: Int = 0
        var totalWeight: Int = 0
        
        if let dataArray = tradeCountData?.data {
            for data in dataArray {
                totalQuantity += Int(data.quantity ?? 0.0)
                totalCount += Int(data.count ?? 0.0)
                totalWeight += Int(data.weight ?? 0.0)
            }
        }
        
        return (totalQuantity, totalCount, totalWeight)
    }
    
    private func displayDateRange() {
        guard let data = tradeCountData?.data, !data.isEmpty else { return }
        
        let startDate = data.first?.date?.prefix(4) ?? "--"
        let endDate = data.last!.date?.prefix(4) ?? "--"
        lblDateRange.text = "\(startDate) - \(endDate)"
    }
    
    private func calculatePercentage(value: Double, date: String) -> Double {
        guard let year = Int(date.prefix(4)),
              let month = Int(date.dropFirst(4).prefix(2)) else { return 100.0 }
        
        let prevYear = year - 1
        let prevDate = String(format: "%04d%02d", prevYear, month)
        let prevRecord = tradeCountData?.data?.first { $0.date == prevDate }
        
        guard let prevRecord = prevRecord else {
            return 100.0
        }
        var percentage: Double = 100.0
        switch chartFilterType {
        case .count:
            let prevCount = prevRecord.count ?? 0.0
            let difference = value - prevCount
            percentage = (difference / (prevCount != 0 ? prevCount : 1.0)) * 100
            
        case .number:
            let prevCount = prevRecord.quantity ?? 0.0
            let difference = value - prevCount
            percentage = (difference / (prevCount != 0 ? prevCount : 1.0)) * 100
            
        case .weight:
            let prevCount = prevRecord.weight ?? 0.0
            let difference = value - prevCount
            percentage = (difference / (prevCount != 0 ? prevCount : 1.0)) * 100
        }
        
        return percentage
    }
    
    
    func moveToTransactionSheetVC() {
        let overViewVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "TransactionOverviewVC") as! TransactionOverviewVC
        if #available(iOS 16.0, *) {
            if let sheet = overViewVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { _ in
                    return 280
                }
                sheet.detents = [customDetent]
                sheet.prefersGrabberVisible = true
            }
        } else {
            if let sheet = overViewVC.sheetPresentationController {
                sheet.detents = [.medium()]
            }
        }
        overViewVC.dataType = buyerSupplierDataType
        overViewVC.selectedState = selectedOverViewState
        overViewVC.selectedStateTapped = { [weak self] selectedState in
            self?.totalCountIndex = 0
            self?.currentIndex = 0
            
//            self?.lblOverView.text = selectedState?.rawValue.getString(for: self?.buyerSupplierDataType ?? 0)
            self?.selectedOverViewState = selectedState
            self?.updateViewState(state: selectedState)
            self?.selectedOverViewStateUpdateCallBack?(selectedState) // To Assign value in Company Detail VC
        }
        present(overViewVC, animated: true)
    }
    
    // MARK: Overview Detail VC
    func moveToOverViewDetailVC(for state: OverViewStates, paramModel: CompanyListParamsModel?) {
        let overviewDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OverviewDetailVC") as! OverviewDetailVC
        overviewDetailVC.overViewState = state
        overviewDetailVC.paramModel = paramModel
        overviewDetailVC.dataType = buyerSupplierDataType
        overviewDetailVC.selectedImportExportType = importExportType
        overviewDetailVC.modalPresentationStyle = .overFullScreen
        present(overviewDetailVC, animated: false)
    }
    
    // MARK: Supplier Detail VC
    func moveToSupplierDetailVC() {
        let supplierDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SupplierDetailVC") as! SupplierDetailVC
        
        supplierDetailVC.dataType = buyerSupplierDataType
        supplierDetailVC.companyName = companyName
        supplierDetailVC.id = supplierData?.data?[currentIndex].id ?? ""
        supplierDetailVC.proportion = calculateProportion(total: supplierData?.baseInfo?.tradeTimes ?? 0, value: supplierData?.data?[currentIndex].count ?? 0.0)
        
        supplierDetailVC.modalPresentationStyle = .overFullScreen
        present(supplierDetailVC, animated: false)
    }
    
    func updateViewState(state: OverViewStates?) {
        switch state {
        case .TransactionOverview:
            lblOverView.text = (state?.rawValue ?? "").localizeString()
            viewTransactionOverview.isHidden = false
            viewSupplier.isHidden = true
            viewTradeArea.isHidden = true
            viewTradeRecords.isHidden = true
            
        case .TradeRecords:
            if tradeRecordsData == nil {
                self.showLoader()
                companyTradeCountDetailVM.tradeRecordsAPI(dataType: buyerSupplierDataType, companyName: companyName)
            } else {
                configureTradeRecordsData(for: currentIndex)
            }
            
        case .Supplier:
            if supplierData == nil {
                // Call Trade Partner API
                self.showLoader()
                companyTradeCountDetailVM.companuyTradePartnerAPI(dataType: buyerSupplierDataType, companyName: companyName)
            } else {
                // Configure Supplier Data
                configureSupplierData(for: currentIndex)
                supplierValuesInViews()
            }
            
        case .HSCode:
            if hsCodeData == nil {
                // Call HS Code API
                self.showLoader()
                companyTradeCountDetailVM.companuyHSCodeAPI(dataType: buyerSupplierDataType, companyName: companyName)
            } else {
                // Configure HS Code Data
                configureHSCodeData(for: currentIndex)
                hsCodeValuesInViews()
            }
            
        case .TradeArea:
            if tradeAreaData == nil {
                self.showLoader()
                companyTradeCountDetailVM.companyTradingAreaAPI(dataType: buyerSupplierDataType, companyName: companyName)
            } else {
                configureTradeAreaData()
            }
            
        case .TradingPort:
            if tradePortData == nil {
                self.showLoader()
                companyTradeCountDetailVM.companyTradePortAPI(dataType: buyerSupplierDataType, companyName: companyName)
            } else {
                // Configure Trade Port Data
                configureTradePortData(for: currentIndex)
                tradePortValuesInViews()
            }
        default:
            break
        }
    }
    
    // MARK: - Custom Actions
    @IBAction func transactionDropDownTapped(_ sender: UIButton) {
        moveToTransactionSheetVC()
    }
    
    @IBAction func monthlyTapped(_ sender: UIButton) {
        graphType = .Monthly
        configureMonthlyYearly()
    }
    
    @IBAction func yearlyTapped(_ sender: UIButton) {
        graphType = .Yearly
        configureMonthlyYearly()
    }
    
    @IBAction func transactionTimesTapped(_ sender: UIButton) {
        chartFilterType = .count
        configureChartsFilter()
        configureMonthlyYearly()
    }
    
    @IBAction func numberOfTransactionTapped(_ sender: UIButton) {
        chartFilterType = .number
        configureChartsFilter()
        configureMonthlyYearly()
    }
    
    @IBAction func transactionWeightTapped(_ sender: UIButton) {
        chartFilterType = .weight
        configureChartsFilter()
        configureMonthlyYearly()
    }
    
    @IBAction func hsCodeBackwardTapped(_ sender: UIButton) {
        if currentIndex > 0 {
            currentIndex -= 1
            switch selectedOverViewState {
                
            case .Supplier:
                configureSupplierData(for: currentIndex)
                
            case .HSCode:
                configureHSCodeData(for: currentIndex)
                
            case .TradingPort:
                configureTradePortData(for: currentIndex)
                
            default:
                break
            }
        }
    }
    
    @IBAction func hsCodeForwardTapped(_ sender: UIButton) {
        if currentIndex < totalCountIndex - 1 {
            currentIndex += 1
            switch selectedOverViewState {
                
            case .Supplier:
                configureSupplierData(for: currentIndex)
                
            case .HSCode:
                configureHSCodeData(for: currentIndex)
                
            case .TradingPort:
                configureTradePortData(for: currentIndex)
                
            default:
                break
            }
        }
    }
    
    @IBAction func tradeRecordsForwardTapped(_ sender: UIButton) {
        if currentIndex < totalCountIndex - 1 {
            currentIndex += 1
            configureTradeRecordsData(for: currentIndex)
        }
    }
    
    @IBAction func tradeRecordsBackwardTapped(_ sender: UIButton) {
        if currentIndex > 0 {
            currentIndex -= 1
            configureTradeRecordsData(for: currentIndex)
        }
    }
    
    @IBAction func viewAllDataTapped(_ sender: UIButton) {
        viewAllDataTappedCallBack?(selectedOverViewState)
    }
    
    @IBAction func tradeAreaViewAllDataTapped(_ sender: UIButton) {
        viewAllDataTappedCallBack?(.TradeArea)
    }
    
    @IBAction func tradeRecordsViewAllDataTapped(_ sender: UIButton) {
        viewAllDataTappedCallBack?(.TradeRecords)
    }
    
    @IBAction func cellTapped(_ sender: UIButton) {
        switch selectedOverViewState {
        case .TransactionOverview:
            break
        case .TradeRecords:
            break
        case .Supplier:
            moveToSupplierDetailVC()
            
        case .HSCode:
            let hsCode = [hsCodeData?.data?[currentIndex].hsCode ?? ""]
            var obj = CompanyListParamsModel(dataType: buyerSupplierDataType, page: 1, pageCount: 10, hsCode: hsCode)
            if buyerSupplierDataType == 0 {
                obj.buyer = companyName
            } else {
                obj.supplier = companyName
            }
            moveToOverViewDetailVC(for: .HSCode, paramModel: obj)
        case .TradeArea:
            var obj = CompanyListParamsModel(dataType: buyerSupplierDataType, page: 1, pageCount: 10)
            if buyerSupplierDataType == 0 {
                obj.buyer = companyName
                obj.buyerCountry = tradeAreaData?.items?[currentIndex].country ?? ""
            } else {
                obj.supplier = companyName
                obj.supplierCountry = tradeAreaData?.items?[currentIndex].country ?? ""
            }
            moveToOverViewDetailVC(for: .TradeArea, paramModel: obj)
            
        case .TradingPort:
            var obj = CompanyListParamsModel(dataType: buyerSupplierDataType, page: 1, pageCount: 10)
            
            if buyerSupplierDataType == 0 {
                obj.buyer = companyName
                obj.exportPort = tradePortData?.items?[currentIndex].port ?? ""
            } else {
                obj.supplier = companyName
                obj.importPort = tradePortData?.items?[currentIndex].port ?? ""
            }
            moveToOverViewDetailVC(for: .TradingPort, paramModel: obj)
            
        case nil:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TradeOverviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tradeAreaData?.items?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tradeAreaCollectionView.dequeueReusableCell(withReuseIdentifier: "TradeAreaCollectionViewCell", for: indexPath) as! TradeAreaCollectionViewCell
        
        cell.vc = self
        cell.configureCell(obj: tradeAreaData, index: indexPath.row)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 4 // Two cells per row
        return CGSize(width: width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 5, bottom: 200, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - Transaction OverView Chart Data
extension TradeOverviewVC {
    private func beautifyChart(chart: CombinedChartView, xMax: Double, xAxisLabels: [String]) {
        let xAxisPadding: Double = 0.45
        
        // Right axis configuration
        let rightAxis = chart.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.valueFormatter = DefaultAxisValueFormatter(block: { value, _ in
            String(format: "%.0f%%", value)
        })
        
        // Left axis configuration
        let leftAxis = chart.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawTopYLabelEntryEnabled = true
        leftAxis.axisMaximum = max(220.0, leftAxis.axisMaximum)
        leftAxis.axisMinimum = 0.0
        
        // X-Axis configuration
        let xAxis = chart.xAxis
        xAxis.axisMinimum = -xAxisPadding
        xAxis.axisMaximum = xMax + xAxisPadding
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        xAxis.granularity = 1.0
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        
        // Calculate maximum values for left and right Y-axis
        let maxLeftYValue = chart.barData?.dataSets.max(by: { $0.yMax < $1.yMax })?.yMax ?? 0.0
        let maxRightYValue = chart.lineData?.dataSets.max(by: { $0.yMax < $1.yMax })?.yMax ?? 0.0
        
        leftAxis.axisMaximum = maxLeftYValue * 1.3
        rightAxis.axisMaximum = maxRightYValue * 1.3
        rightAxis.axisMinimum = 0.0
        
        // General chart settings
        chart.isUserInteractionEnabled = false
        chart.chartDescription.enabled = false
        chart.legend.enabled = false
        chart.drawValueAboveBarEnabled = false
        
        // Refresh chart
        chart.notifyDataSetChanged()
        chart.setNeedsDisplay()
        
        // Animation
        chart.animate(xAxisDuration: 0.5, easingOption: .easeInCirc)
    }
    
    private func getGraphData(bars: [BarChartDataEntry], lines: [ChartDataEntry]) -> CombinedChartData {
        let barDataSet = BarChartDataSet(entries: bars, label: "Bar Data")
        var colors: [UIColor] = []
        
        switch chartFilterType {
        case .count:
            colors = [UIColor.hexStringToUIColor(hex: "#596FC0")]
        case .number:
            colors = [UIColor.hexStringToUIColor(hex: "#9ECA7E")]
        case .weight:
            colors = [UIColor.hexStringToUIColor(hex: "#5350BE")]
        }
        
        barDataSet.colors = colors // Customize colors if needed
        barDataSet.drawValuesEnabled = false
        let barData = BarChartData(dataSet: barDataSet)
        
        let lineDataSet = LineChartDataSet(entries: lines, label: "Line Data")
        lineDataSet.colors = [UIColor.hexStringToUIColor(hex: "#F2CD73")]
        lineDataSet.circleColors = [UIColor.hexStringToUIColor(hex: "#F2CD73")]
        lineDataSet.circleRadius = 3
        lineDataSet.circleHoleRadius = 0
        lineDataSet.drawValuesEnabled = false
        let lineData = LineChartData(dataSet: lineDataSet)
        let combinedData = CombinedChartData()
        combinedData.barData = barData
        combinedData.lineData = lineData
        
        return combinedData
    }
    
    private func displayMonthlyGraph() {
        
        guard let data = tradeCountData?.data else { return }
        
        var bars = [BarChartDataEntry]()
        var lines = [ChartDataEntry]()
        var xAxisLabels = [String]()
        
        let maxGraph = min(12, data.count)
        let startIndex = max(0, data.count - maxGraph)
        
        for (index, counter) in (startIndex..<(startIndex + maxGraph)).enumerated() {
            let item = data[index]
            let value: Double
            
            switch chartFilterType {
            case .count:
                value = item.count ?? 0.0
            case .number:
                value = item.quantity ?? 0.0
            case .weight:
                value = item.weight ?? 0.0
            }
            
            bars.append(BarChartDataEntry(x: Double(index), y: value))
            lines.append(ChartDataEntry(x: Double(index), y: value))//calculatePercentage(value: value, date: item.date ?? "")))
            xAxisLabels.append(item.date ?? "")
        }
        
        let combinedData = getGraphData(bars: bars, lines: lines)
        viewCombinedChart.data = combinedData
        
        viewCombinedChart.notifyDataSetChanged()
        viewCombinedChart.setNeedsDisplay()
        beautifyChart(chart: viewCombinedChart, xMax: combinedData.xMax, xAxisLabels: xAxisLabels)
    }
    
    private func displayYearlyGraph() {
        guard let mData = generateYearlyData() else { return }
        
        var bars: [BarChartDataEntry] = []
        var lines: [ChartDataEntry] = []
        var xAxisLabels: [String] = []
        
        let maxGraph = min(4, mData.data?.count ?? 0)
        let startIndex = max((mData.data?.count ?? 0) - maxGraph, 0)
        
        for index in (startIndex..<(startIndex + maxGraph)) {
            guard let item = mData.data?[index] else { continue }
            let value: Double
            switch chartFilterType {
            case .count:
                value = item.count ?? 0.0
            case .number:
                value = item.quantity ?? 0.0
            case .weight:
                value = item.weight ?? 0.0
            }
            
            bars.append(BarChartDataEntry(x: Double(index), y: value))
            lines.append(ChartDataEntry(x: Double(index), y: value))
            xAxisLabels.append(item.date ?? "")
        }
        
        let combinedData = getGraphData(bars: bars, lines: lines)
        viewCombinedChart.data = combinedData
        beautifyChart(chart: viewCombinedChart, xMax: combinedData.xMax, xAxisLabels: xAxisLabels)
    }
    
    private func calculatePercentageYearly(value: String, date: String) -> Double {
        guard let year = Int(date.prefix(4)) else { return 100.0 }
        let prevYear = year - 1
        let prevDate = String(format: "%04d", prevYear)
        guard let prevRecord = tradeCountData?.data?.first(where: { $0.date == prevDate }) else {
            return 100.0
        }
        
        switch chartFilterType {
        case .count:
            if let valueDouble = Double(value) {
                return Double(((valueDouble - (prevRecord.count ?? 0.0)) / (prevRecord.count ?? 0.0)) * 100)
            }
        case .number:
            if let valueDouble = Double(value) {
                return Double(((valueDouble - (prevRecord.quantity ?? 0.0)) / (prevRecord.quantity ?? 0.0)) * 100)
            }
        case .weight:
            if let valueDouble = Double(value) {
                return Double(((valueDouble - (prevRecord.weight ?? 0.0)) / (prevRecord.weight ?? 0.0)) * 100)
            }
        }
        
        return 100.0
    }
    
    private func configureChartsFilter() {
        switch chartFilterType {
        case .count:
            lblTransactionTimesFilter.textColor = UIColor.hexStringToUIColor(hex: "#596FC0")
            viewTransactionTimes.backgroundColor = UIColor.hexStringToUIColor(hex: "#596FC0")
            
            lblNumOfTransactionsFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewNumOfTransactions.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblTransactionWeightFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionWeight.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
        case .number:
            lblTransactionTimesFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionTimes.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblNumOfTransactionsFilter.textColor = UIColor.hexStringToUIColor(hex: "#9ECA7E")
            viewNumOfTransactions.backgroundColor = UIColor.hexStringToUIColor(hex: "#9ECA7E")
            
            lblTransactionWeightFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionWeight.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
        case .weight:
            lblTransactionTimesFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewTransactionTimes.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblNumOfTransactionsFilter.textColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            viewNumOfTransactions.backgroundColor = UIColor.hexStringToUIColor(hex: "#CCCCCC")
            
            lblTransactionWeightFilter.textColor = UIColor.hexStringToUIColor(hex: "#5350BE")
            viewTransactionWeight.backgroundColor = UIColor.hexStringToUIColor(hex: "#5350BE")
        }
    }
    
    private func generateYearlyData() -> TradeCountModel? {
        let data = TradeCountModel(credits: tradeCountData?.credits, baseInfo: tradeCountData?.baseInfo, data: aggregateByYear(dataList: tradeCountData?.data ?? []))
        return data
    }
    
    private func aggregateByYear(dataList: [GraphData]) -> [GraphData] {
        let groupedData = Dictionary(grouping: dataList) { $0.date?.prefix(4) }
        return groupedData.map { (year, dataInYear) in
            let totalQuantity = dataInYear.reduce(0) { $0 + (Int($1.quantity ?? 0.0)) }
            let totalCount = dataInYear.reduce(0) { $0 + (Int($1.count ?? 0.0)) }
            let totalWeight = dataInYear.reduce(0) { $0 + (Int($1.weight ?? 0.0)) }
            return GraphData(date: String(year ?? ""), quantity: Double(totalQuantity), count: Double(totalCount), weight: Double(totalWeight))
        }
        .sorted { ($0.date ?? "") < ($1.date ?? "") }
    }
}

// MARK: - Trade Records Data
extension TradeOverviewVC {
    func configureTradeRecordsData(for index: Int) {
        guard let obj = tradeRecordsData else { return }
        lblOverView.text = (selectedOverViewState?.rawValue ?? "").localizeString()
        viewTradeRecords.isHidden = false
        viewSupplier.isHidden = true
        viewTransactionOverview.isHidden = true
        viewTradeArea.isHidden = true
        
        totalCountIndex = (obj.data?.list?.count ?? 0).getTotalCount(for: 15)
        lblTradeRecordsMaxIndex.text = "\(totalCountIndex)"
        lblTradeRecordsCurrentIndex.text = "\(currentIndex + 1)"
        
        lblTradeRecordTotalNumOfTrans.text = obj.data?.total ?? ""//""
        lblTradeRecordTradingTimes.text = "\(obj.baseInfo?.tradeTimes ?? 0)"
        lblTradeRecordDate.text = obj.data?.list?[currentIndex].date?.convertSecondsToDateString()
        lblTradeRecordBillNum.text = obj.data?.list?[currentIndex].billOfLading ?? ""
        lblTradeRecordsSupplyingCountry.text = (obj.data?.list?[currentIndex].exporterCountry ?? "").getCountryName()
        lblTradeRecordsPurchasingCountry.text = (obj.data?.list?[currentIndex].importerCountry ?? "").getCountryName()
        lblTradeRecordsHSCode.text = (obj.data?.list?[currentIndex].hsCode ?? "").checkString()
        lblTradeRecordsQuantity.text = "\(obj.data?.list?[currentIndex].quantity ?? 0.0)\(obj.data?.list?[currentIndex].quantityUnit ?? "")".checkString()
        lblTradeRecordsWeight.text = "\(obj.data?.list?[currentIndex].grossWeight ?? 0.0)\(obj.data?.list?[currentIndex].weightUnit ?? "")".checkString()
        lblTradeRecordsAmount.text = "\(obj.data?.list?[currentIndex].amountUSD ?? 0.0)USD"
        lblTradeRecordsTransportMode.text = (obj.data?.list?[currentIndex].transportMethod ?? "").checkString()
        lblTradeRecordsExportPort.text = (obj.data?.list?[currentIndex].foreignPort ?? "").checkString()
        lblTradeRecordsPortOfEntry.text = (obj.data?.list?[currentIndex].localPort ?? "").checkString()
        lblTradeRecordsBuyer.text = (obj.data?.list?[currentIndex].importer ?? "").checkString()
        lblTradeRecordsSupplier.text = (obj.data?.list?[currentIndex].exporter ?? "").checkString()
        lblTradingProducts.text = (obj.data?.list?[currentIndex].detailedProductName ?? "").checkString()
    }
}

// MARK: - Supplier Chart Data
extension TradeOverviewVC {
    func configureSupplierData(for index: Int) {
        guard let obj = supplierData else { return }
        lblOverView.text = (selectedOverViewState?.rawValue ?? "").getString(for: buyerSupplierDataType).localizeString()
        totalCountIndex = (obj.data?.count ?? 0).getTotalCount(for: 5)
        lblTotalDataCount.text = "\(totalCountIndex)"
        lblCurrentStateCount.text = "\(currentIndex + 1)"
        
        lblTitleHSCode.text = "Number of transactions".localizeString()
        lblTitleNumOfTransaction.text = "Supplier".getString(for: buyerSupplierDataType).localizeString()
        lblTotalCountTitle.text = buyerSupplierDataType == 0 ? "Number of Suppliers".localizeString() : "Number of Buyers".localizeString()
        lblSupplierDate.isHidden = false
        viewSupplier.isHidden = false
        viewTransactionOverview.isHidden = true
        viewTradeRecords.isHidden = true
        viewTradeArea.isHidden = true
        
        guard obj.data?.count > 0 else { return }
        
        lblSupplierDate.text = Int(obj.data?[index].timeStamp ?? 0).convertSecondsToDateString()
        lblHSCodeData.text = "\(obj.baseInfo?.tradeTimes ?? 0)"
        lblTransactionCount.text = obj.data?[index].name ?? ""
        lblProportion.text = calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: obj.data?[index].count ?? 0.0)
        lblTotalData.text = "\(obj.data?.count ?? 0)"
    }
    
    func supplierValuesInViews() {
        
        let tradeTimes = supplierData?.baseInfo?.tradeTimes ?? 0
        var left: Double = 100.0
        
        var entries: [PieChartDataEntry] = []
        var colors: [UIColor] = []
        let colorCodes = [
            "#FF4314", "#FF6600", "#FF9F16", "#2962FF", "#3699FF"
        ]
        var index = 0
        
        supplierData?.data?.forEach { data in
            // Calculate the proportion
            let proportion = calculateProportionToDouble(total: tradeTimes, value: Double(data.count ?? 0))
            
            left -= proportion
            
            // Add the entry to the chart
            entries.append(PieChartDataEntry(value: proportion))
            if index < colorCodes.count {
                colors.append(UIColor.hexStringToUIColor(hex: colorCodes[index]))
            }
            index += 1
        }
        
        // Add the remaining "other" slice if applicable
        if left > 0.0 {
            entries.append(PieChartDataEntry(value: left))
            colors.append(UIColor.hexStringToUIColor(hex: "#EFF3F7"))
        }
        
        // Create the dataset
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.sliceSpace = 2.0
        dataSet.drawValuesEnabled = false
        dataSet.colors = colors
        
        // Create PieData and set it to the chart
        let data = PieChartData(dataSet: dataSet)
        pieChartSupplier.data = data
        
        // Customize the pie chart
        pieChartSupplier.drawHoleEnabled = true
        pieChartSupplier.usePercentValuesEnabled = true
        pieChartSupplier.legend.enabled = false
        pieChartSupplier.chartDescription.enabled = false
        
        // Add animations
        pieChartSupplier.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
}

// MARK: - HSCode Chart Data
extension TradeOverviewVC {
    func configureHSCodeData(for index: Int) {
        guard let obj = hsCodeData else { return }
        lblOverView.text = (selectedOverViewState?.rawValue ?? "").localizeString()
        
        totalCountIndex = (obj.data?.count ?? 0).getTotalCount(for: 5)
        lblTotalDataCount.text = "\(totalCountIndex)"
        lblCurrentStateCount.text = "\(currentIndex + 1)"
        
        lblTitleHSCode.text = "HS Code Name".localizeString()
        lblTitleNumOfTransaction.text = "Number of transactions".localizeString()
        lblTotalCountTitle.text = "Total trade volume by HS code".localizeString()
        
        lblSupplierDate.isHidden = true
        viewTradeRecords.isHidden = true
        viewSupplier.isHidden = false
        viewTransactionOverview.isHidden = true
        viewTradeArea.isHidden = true
        
        guard obj.data?.count > 0 else { return }
        
        lblHSCodeData.text = obj.data?[index].hsCode ?? ""
        lblProportion.text = calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: Double(obj.data?[index].count ?? 0))
        lblTransactionCount.text = "\(obj.baseInfo?.tradeTimes ?? 0)"
        lblTotalData.text = "\(obj.data?.count ?? 0)"
    }
    
    func hsCodeValuesInViews() {
        
        let tradeTimes = hsCodeData?.baseInfo?.tradeTimes ?? 0
        var left: Double = 100.0
        
        var entries: [PieChartDataEntry] = []
        var colors: [UIColor] = []
        let colorCodes = [
            "#FF4314", "#FF6600", "#FF9F16", "#2962FF", "#3699FF"
        ]
        var index = 0
        
        hsCodeData?.data?.forEach { data in
            // Calculate the proportion
            let proportion = calculateProportionToDouble(total: tradeTimes, value: Double(data.count ?? 0))
            
            left -= proportion
            
            // Add the entry to the chart
            entries.append(PieChartDataEntry(value: proportion))
            if index < colorCodes.count {
                colors.append(UIColor.hexStringToUIColor(hex: colorCodes[index]))
            }
            index += 1
        }
        
        // Add the remaining "other" slice if applicable
        if left > 0.0 {
            entries.append(PieChartDataEntry(value: left))
            colors.append(UIColor.hexStringToUIColor(hex: "#EFF3F7"))
        }
        
        // Create the dataset
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.sliceSpace = 2.0
        dataSet.drawValuesEnabled = false
        dataSet.colors = colors
        
        // Create PieData and set it to the chart
        let data = PieChartData(dataSet: dataSet)
        pieChartSupplier.data = data
        
        // Customize the pie chart
        pieChartSupplier.drawHoleEnabled = true
        pieChartSupplier.usePercentValuesEnabled = true
        pieChartSupplier.legend.enabled = false
        pieChartSupplier.chartDescription.enabled = false
        
        // Add animations
        pieChartSupplier.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
}

// MARK: - TradeArea Data
extension TradeOverviewVC {
    func configureTradeAreaData() {
        lblOverView.text = (selectedOverViewState?.rawValue ?? "").localizeString()
        viewSupplier.isHidden = true
        viewTransactionOverview.isHidden = true
        viewTradeArea.isHidden = false
        viewTradeRecords.isHidden = true
        tradeAreaCollectionView.reloadData()
    }
}

// MARK: - Trade Port Chart Data
extension TradeOverviewVC {
    func configureTradePortData(for index: Int) {
        guard let obj = tradePortData else { return }
        lblOverView.text = (selectedOverViewState?.rawValue ?? "").localizeString()
        totalCountIndex = (obj.items?.count ?? 0).getTotalCount(for: 5)
        lblTotalDataCount.text = "\(totalCountIndex)"
        lblCurrentStateCount.text = "\(currentIndex + 1)"
        
        lblTitleHSCode.text = "Port Name".localizeString()
        lblTitleNumOfTransaction.text = "Number of transactions".localizeString()
        lblTotalCountTitle.text = "The total trade volume of the port".localizeString()
        lblSupplierDate.isHidden = true
        viewSupplier.isHidden = false
        viewTransactionOverview.isHidden = true
        viewTradeArea.isHidden = true
        viewTradeRecords.isHidden = true
        
        guard obj.items?.count > 0 else { return }
        
        lblSupplierDate.text = Int(obj.items?[index].timeStamp ?? 0).convertSecondsToDateString()
        lblHSCodeData.text = obj.items?[index].port ?? "-- --"
        lblTransactionCount.text = "\(obj.baseInfo?.tradeTimes ?? 0)"
        lblProportion.text = calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: Double(obj.items?[index].count ?? 0))
        lblTotalData.text = "\(obj.items?.count ?? 0)"
    }
    
    func tradePortValuesInViews() {
        
        let tradeTimes = tradePortData?.baseInfo?.tradeTimes ?? 0
        var left: Double = 100.0
        
        var entries: [PieChartDataEntry] = []
        var colors: [UIColor] = []
        let colorCodes = [
            "#FF4314", "#FF6600", "#FF9F16", "#2962FF", "#3699FF"
        ]
        var index = 0
        
        tradePortData?.items?.forEach { data in
            // Calculate the proportion
            let proportion = calculateProportionToDouble(total: tradeTimes, value: Double(data.count ?? 0))
            
            left -= proportion
            
            // Add the entry to the chart
            entries.append(PieChartDataEntry(value: proportion))
            if index < colorCodes.count {
                colors.append(UIColor.hexStringToUIColor(hex: colorCodes[index]))
            }
            index += 1
        }
        
        // Add the remaining "other" slice if applicable
        if left > 0.0 {
            entries.append(PieChartDataEntry(value: left))
            colors.append(UIColor.hexStringToUIColor(hex: "#EFF3F7"))
        }
        
        // Create the dataset
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.sliceSpace = 2.0
        dataSet.drawValuesEnabled = false
        dataSet.colors = colors
        
        // Create PieData and set it to the chart
        let data = PieChartData(dataSet: dataSet)
        pieChartSupplier.data = data
        
        // Customize the pie chart
        pieChartSupplier.drawHoleEnabled = true
        pieChartSupplier.usePercentValuesEnabled = true
        pieChartSupplier.legend.enabled = false
        pieChartSupplier.chartDescription.enabled = false
        
        // Add animations
        pieChartSupplier.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
}

// MARK: - CompanyTradeCountDetailDelegate
extension TradeOverviewVC: CompanyTradeCountDetailDelegate {
    func didReceiveCompanyTradePartnerResponse(response: TradePartnerModel?, error: String?) {
        self.hideLoader()
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                supplierUpdatedCallBack?(response)
                supplierData = response
                configureSupplierData(for: currentIndex)
                supplierValuesInViews()
                
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
    
    func didReceiveCompanyHSCodeResponse(response: HSCodeModel?, error: String?) {
        self.hideLoader()
        
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                hsCodeUpdatedCallBack?(response)
                hsCodeData = response
                configureHSCodeData(for: currentIndex)
                hsCodeValuesInViews()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
    
    func didReceiveCompanyTradingAreaResponse(response: TradeAreaModel?, error: String?) {
        self.hideLoader()
        
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                tradeAreaData = response
                tradeAreaUpdatedCallBack?(response)
                configureTradeAreaData()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
    
    func didReceiveCompanyTradePortResponse(response: TradePortModel?, error: String?) {
        self.hideLoader()
        
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                tradePortUpdatedCallBack?(response)
                tradePortData = response
                configureTradePortData(for: currentIndex)
                tradePortValuesInViews()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
    
    func didReceiveCompanyTradeRecordsResponse(response: TradeListModel?, error: String?) {
        self.hideLoader()
        
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                tradeRecordsData = response
                tradeRecordsUpdatedCallBack?(response)
                configureTradeRecordsData(for: currentIndex)
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
}
