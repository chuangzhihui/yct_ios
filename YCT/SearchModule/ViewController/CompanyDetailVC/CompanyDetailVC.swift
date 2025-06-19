//
//  CompanyDetailVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 11/11/2024.
//

import UIKit

struct TradeFilterModel {
    var title: String
    var count: Int
    var isSelected: Bool = false
}

enum TradesType {
    case HSCode
    case TradeArea
    case TradingPort
}

class CompanyDetailVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tradeCollectionView: UICollectionView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblCompanyContactTitle: UILabel!
    
    // MARK: - Varible & Constants
    var tradeFilterData: [TradeFilterModel] = [
        TradeFilterModel(title: "Trade Overview", count: 0, isSelected: true),
        TradeFilterModel(title: "Transaction Records", count: 0),
        TradeFilterModel(title: "Suppliers", count: 0),
        TradeFilterModel(title: "HS Code", count: 0),
        TradeFilterModel(title: "Trade Area", count: 0),
        TradeFilterModel(title: "Trading Ports", count: 0),
    ]
    var companyTradeCountDetailVM: CompanyTradeCountDetailViewModel = CompanyTradeCountDetailViewModel()
    var importExportType: ImportExportType = .Import
    var selectedOverViewState: OverViewStates? = .TransactionOverview
    var selectedIndex: Int = 0
    var companyName: String = ""
    var dataType: Int = 0 // Buyer Supplier Data Type
    var tradeCountData: TradeCountModel? // Trade Count Data
    var tradeRecordsData: TradeListModel?
    
    var transactionRecordsData: CompanyListModel? // Transactions Records Data
    var filtredTransactionsRecordsData: CompanyListModel?
    var TransactionsProductsSearchTxt: String = ""
    var TransactionshsCodeSearchTxt: String = ""
    var TransactionsSupplierSearchTxt: String = ""
    var TransactionsStartTimeSearchTxt: Int = 0
    var TransactionsEndTimeSearchTxt: Int = 0
    var TransactionsPortsSearchTxt: String = ""
    var TransactionsBillSearchTxt: String = ""
    var TransactionsCountrySearchTxt: String = ""
    var companyListVM: CompanyListViewModel = CompanyListViewModel()
    var currentPage: Int = 1
    var pageCount: Int = 10
    var isLoadingData: Bool = true
    var noMoreData: Bool = false
    var currentYear: Int = 1
    
    var hsCodeData: HSCodeModel? // HS Code Data
    var hsCodeSearchText: String = ""
    var filteredHSCodeData: HSCodeModel?
    
    var supplierData: TradePartnerModel? // Supplier Data
    var supplierSearchText: String = ""
    var countrySearchText: String = ""
    var filteredSupplierData: TradePartnerModel?
    
    var tradeAreaData: TradeAreaModel? // Trade Area Data
    var tradeAreaSearchText: String = ""
    var filteredTradeAreaData: TradeAreaModel?
    
    var tradePortData: TradePortModel? // Trade Port Data
    var tradingPortSearchText: String = ""
    var filteredTradingPortData: TradePortModel?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentYear = getCurrentYear()
        lblHeaderTitle.text = companyName.uppercased()
        companyTradeCountDetailVM.delegate = self
        companyListVM.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        configureCollectionView()
        configureLanguage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tradeCountData == nil {
            self.showLoader()
            companyTradeCountDetailVM.tradeCountDetailAPI(dataType: dataType, companyName: companyName)
        } else {
            moveToTradeOverviewVC()
        }
    }
    
    // MARK: - Custom Functions
    func configureLanguage() {
        lblCompanyContactTitle.text = "Company Contact".localizeString()
    }
    
    func configureCollectionView() {
        let cellNib = UINib(nibName: "TradeFilterCell", bundle: nil)
        tradeCollectionView.register(cellNib, forCellWithReuseIdentifier: "TradeFilterCell")
        tradeCollectionView.delegate = self
        tradeCollectionView.dataSource = self
    }
    
    func getCurrentYear() -> Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return currentYear
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
    
    func callTransactionRecordsAPI() {
        self.showLoader()
        let time = getStartAndEndTime(of: currentYear)
        var obj = CompanyListParamsModel(dataType: dataType, page: currentPage, pageCount: pageCount, startTime: time?.startTime, endTime: time?.endTime)
        if dataType == 0 {
            obj.buyer = companyName
        } else {
            obj.supplier = companyName
        }
        companyListVM.companyListAPI(obj: obj)
    }
    
    func moveToContactDetailVC() {
        let contactDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailVC") as! ContactDetailVC
        contactDetailVC.modalPresentationStyle = .overFullScreen
        contactDetailVC.companyName = companyName
        present(contactDetailVC, animated: false)
    }
    
    // Trade Records VC
    func moveToTradeOverviewVC() {
        viewFilter.isHidden = true
        let tradeOverviewVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "TradeOverviewVC") as! TradeOverviewVC
        addChild(tradeOverviewVC)
        
        tradeOverviewVC.selectedOverViewStateUpdateCallBack = { [weak self] updatedOverViewState in
            self?.selectedOverViewState = updatedOverViewState
        }
        
        tradeOverviewVC.tradeRecordsUpdatedCallBack = { [weak self] tradeRecordsUpdatedData in
            self?.tradeRecordsData = tradeRecordsUpdatedData
        }
        
        // Supplier Data Call Back
        tradeOverviewVC.supplierUpdatedCallBack = { [weak self] supplierData in
            self?.supplierData = supplierData
        }
        
        // HSCode Data Call Back
        tradeOverviewVC.hsCodeUpdatedCallBack = { [weak self] hsCodeData in
            self?.hsCodeData = hsCodeData
        }
        
        // Trade Area Data Call Back
        tradeOverviewVC.tradeAreaUpdatedCallBack = { [weak self] tradeAreaData in
            self?.tradeAreaData = tradeAreaData
        }
        
        // Trade Port Data Call Back
        tradeOverviewVC.tradePortUpdatedCallBack = { [weak self] tradePortData in
            self?.tradePortData = tradePortData
        }
        
        // View All Data Tapped Call Back
        tradeOverviewVC.viewAllDataTappedCallBack = { [weak self] overViewState in
            self?.viewContent.subviews.forEach { $0.removeFromSuperview() }
            if let index = self?.tradeFilterData.firstIndex(where: { $0.isSelected == true }) {
                self?.tradeFilterData[index].isSelected = false
            }
            switch overViewState {
            case .TradeRecords:
                self?.moveToTransactionsRecordsVC()
                self?.tradeFilterData[1].isSelected = true
                
            case .Supplier:
                self?.moveToSupplierVC()
                self?.tradeFilterData[2].isSelected = true
                
            case .HSCode:
                self?.moveToHSCodeVC()
                self?.tradeFilterData[3].isSelected = true
                
            case .TradeArea:
                self?.moveToTradeAreaVC()
                self?.tradeFilterData[4].isSelected = true
                
            case .TradingPort:
                self?.moveToTradingPortVC()
                self?.tradeFilterData[5].isSelected = true
                
            default:
                break
            }
            self?.tradeCollectionView.reloadData()
        }
        
        tradeOverviewVC.selectedOverViewState = selectedOverViewState
        tradeOverviewVC.importExportType = importExportType
        tradeOverviewVC.buyerSupplierDataType = dataType
        tradeOverviewVC.companyName = companyName
        tradeOverviewVC.tradeCountData = tradeCountData // TransactionOverView Data
        tradeOverviewVC.tradeRecordsData = tradeRecordsData
        tradeOverviewVC.hsCodeData = hsCodeData // HS Code Data
        tradeOverviewVC.supplierData = supplierData // Supplier Data
        tradeOverviewVC.tradeAreaData = tradeAreaData // Trade Area Data
        tradeOverviewVC.tradePortData = tradePortData // Trade Port Data
        
        viewContent.addSubview(tradeOverviewVC.view)
        tradeOverviewVC.didMove(toParent: self)
    }
    
    // Transaction Records VC
    func moveToTransactionsRecordsVC() {
        viewFilter.isHidden = false
        let transactionsRecordsVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "TransactionsRecordsVC") as! TransactionsRecordsVC
        
        transactionsRecordsVC.dataType = dataType
        transactionsRecordsVC.importExportType = importExportType
        transactionsRecordsVC.companyName = companyName
        transactionsRecordsVC.currentYear = currentYear
        
        if TransactionsProductsSearchTxt.isEmpty && TransactionshsCodeSearchTxt.isEmpty && TransactionsSupplierSearchTxt.isEmpty && TransactionsPortsSearchTxt.isEmpty && TransactionsBillSearchTxt.isEmpty && TransactionsCountrySearchTxt.isEmpty {
            transactionsRecordsVC.transactionRecordsData = transactionRecordsData
        } else {
            transactionsRecordsVC.transactionRecordsData = filtredTransactionsRecordsData
        }
        
        transactionsRecordsVC.currentPage = currentPage
        transactionsRecordsVC.noMoreData = noMoreData
        transactionsRecordsVC.isLoadingData = isLoadingData
        
        transactionsRecordsVC.didChangeYearCallBack = { [weak self] intYear in
            self?.currentYear = intYear
            self?.transactionRecordsData = nil
            self?.currentPage = 1
            self?.isLoadingData = true
            self?.noMoreData = false
            self?.callTransactionRecordsAPI()
        }
        
        transactionsRecordsVC.scrollCallBack = { [weak self] in
            self?.isLoadingData = true
            self?.callTransactionRecordsAPI()
        }
        
        addChild(transactionsRecordsVC)
        viewContent.addSubview(transactionsRecordsVC.view)
        transactionsRecordsVC.didMove(toParent: self)
    }
    
    // Transaction Records Filter VC
    func openTransactionRecordSheet() {
        let transactionRecordSheet = UIStoryboard(name: "FilterViews", bundle: nil).instantiateViewController(withIdentifier: "TransactionRecordFilterVC") as! TransactionRecordFilterVC
        transactionRecordSheet.modalPresentationStyle = .overFullScreen
        transactionRecordSheet.dataType = dataType
        transactionRecordSheet.TransactionsProductsSearchTxt = TransactionsProductsSearchTxt
        transactionRecordSheet.TransactionshsCodeSearchTxt = TransactionshsCodeSearchTxt
        transactionRecordSheet.TransactionsSupplierSearchTxt = TransactionsSupplierSearchTxt
        transactionRecordSheet.TransactionsStartTimeSearchTxt = TransactionsStartTimeSearchTxt
        transactionRecordSheet.TransactionsEndTimeSearchTxt = TransactionsEndTimeSearchTxt
        transactionRecordSheet.TransactionsPortsSearchTxt = TransactionsPortsSearchTxt
        transactionRecordSheet.TransactionsBillSearchTxt = TransactionsBillSearchTxt
        transactionRecordSheet.TransactionsCountrySearchTxt = TransactionsCountrySearchTxt
        
        transactionRecordSheet.filterDataCallBack = { [weak self] products, hsCode, supplier, startTime, endTime, ports, bill, country  in
            self?.TransactionsProductsSearchTxt = products
            self?.TransactionshsCodeSearchTxt = hsCode
            self?.TransactionsSupplierSearchTxt = supplier
            self?.TransactionsStartTimeSearchTxt = startTime
            self?.TransactionsEndTimeSearchTxt = endTime
            self?.TransactionsPortsSearchTxt = ports
            self?.TransactionsBillSearchTxt = bill
            self?.TransactionsCountrySearchTxt = country
            
            let matches = self?.transactionRecordsData?.lists?.filter({
                $0.products?.lowercased().contains(products.lowercased()) == true ||
                $0.country?.getCountryName().lowercased().contains(country.lowercased()) == true ||
                $0.hsCode?.contains(hsCode) == true ||
                $0.importPort?.contains(ports) == true ||
                $0.exportPort?.contains(ports) == true ||
                $0.tradeCorporate?.contains(supplier) == true ||
                $0.corporate?.contains(supplier) == true ||
                $0.ladingNumber?.contains(bill) == true
            })
            
            self?.filtredTransactionsRecordsData = self?.transactionRecordsData
            self?.filtredTransactionsRecordsData?.lists = matches
            self?.moveToTransactionsRecordsVC()
        }
        
        present(transactionRecordSheet, animated: false, completion: nil)
    }
    
    // Supplier VC
    func moveToSupplierVC() {
        viewFilter.isHidden = false
        let supplierVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "SupplierVC") as! SupplierVC
        addChild(supplierVC)
        if supplierSearchText.isEmpty && countrySearchText.isEmpty {
            supplierVC.supplierData = supplierData
        } else {
            supplierVC.supplierData = filteredSupplierData
        }
        supplierVC.dataType = dataType
        supplierVC.companyName = companyName
        viewContent.addSubview(supplierVC.view)
        supplierVC.didMove(toParent: self)
    }
    
    // Filter Supplier VC
    func openSupplierFilterSheet() {
        let filterSupplierVC = UIStoryboard(name: "FilterViews", bundle: nil).instantiateViewController(withIdentifier: "FilterSupplierVC") as! FilterSupplierVC
        
        filterSupplierVC.supplierFilterCallBack = { [weak self] supplierTxt, countryTxt in
            self?.supplierSearchText = supplierTxt
            self?.countrySearchText = countryTxt
            let matches = self?.supplierData?.data?.filter({
                $0.name?.lowercased().contains(supplierTxt.lowercased()) == true ||
                $0.country?.getCountryName().lowercased().contains(countryTxt.lowercased()) == true
            })
            self?.filteredSupplierData = self?.supplierData
            self?.filteredSupplierData?.data = matches
            self?.moveToSupplierVC()
        }
        
        filterSupplierVC.supplierSearchText = supplierSearchText
        filterSupplierVC.countrySearchText = countrySearchText
        
        filterSupplierVC.modalPresentationStyle = .overFullScreen
        present(filterSupplierVC, animated: false)
    }
    
    // HS Code VC
    func moveToHSCodeVC() {
        viewFilter.isHidden = false
        let hsCodeVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "HSCodeVC") as! HSCodeVC
        if hsCodeSearchText.isEmpty {
            hsCodeVC.hsCodeData = hsCodeData
        } else {
            hsCodeVC.hsCodeData = filteredHSCodeData
        }
        hsCodeVC.dataType = dataType
        hsCodeVC.companyName = companyName
        hsCodeVC.importExportType = importExportType
        addChild(hsCodeVC)
        viewContent.addSubview(hsCodeVC.view)
        hsCodeVC.didMove(toParent: self)
    }
    
    // Trade Area VC
    func moveToTradeAreaVC() {
        viewFilter.isHidden = false
        let tradeAreaVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "TradeAreaVC") as! TradeAreaVC
        
        if tradeAreaSearchText.isEmpty {
            tradeAreaVC.tradeAreaData = tradeAreaData
        } else {
            tradeAreaVC.tradeAreaData = filteredTradeAreaData
        }
        tradeAreaVC.dataType = dataType
        addChild(tradeAreaVC)
        viewContent.addSubview(tradeAreaVC.view)
        tradeAreaVC.didMove(toParent: self)
    }
    
    // Trading Port VC
    func moveToTradingPortVC() {
        viewFilter.isHidden = false
        let tradingPortVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "TradingPortVC") as! TradingPortVC
        if tradingPortSearchText.isEmpty {
            tradingPortVC.tradePortData = tradePortData
        } else {
            tradingPortVC.tradePortData = filteredTradingPortData
        }
        tradingPortVC.dataType = dataType
        tradingPortVC.companyName = companyName
        addChild(tradingPortVC)
        viewContent.addSubview(tradingPortVC.view)
        tradingPortVC.didMove(toParent: self)
    }
    
    // Trading Port Filter VC
    func openTradingFilterSheet(tradeType: TradesType) {
        let tradingPortFilterVC = UIStoryboard(name: "FilterViews", bundle: nil).instantiateViewController(withIdentifier: "TradingPortFilterVC") as! TradingPortFilterVC
        
        tradingPortFilterVC.modalPresentationStyle = .overFullScreen
        
        tradingPortFilterVC.filterDataCallBack = { [weak self] str in
            switch tradeType {
            case .HSCode:
                self?.hsCodeSearchText = str
                let matches = self?.hsCodeData?.data?.filter {
                    $0.hsCode?.contains(str.lowercased()) == true
                }
                self?.filteredHSCodeData = self?.hsCodeData
                self?.filteredHSCodeData?.data = matches
                self?.moveToHSCodeVC()
            case .TradeArea:
                self?.tradeAreaSearchText = str
                let matches = self?.tradeAreaData?.items?.filter {
                    $0.country?.getCountryName().lowercased().contains(str.lowercased()) == true
                }
                self?.filteredTradeAreaData = self?.tradeAreaData
                self?.filteredTradeAreaData?.items = matches
                self?.moveToTradeAreaVC()
                
            case .TradingPort:
                self?.tradingPortSearchText = str
                let matches = self?.tradePortData?.items?.filter {
                    $0.port?.lowercased().contains(str.lowercased()) == true
                }
                self?.filteredTradingPortData = self?.tradePortData
                self?.filteredTradingPortData?.items = matches
                self?.moveToTradingPortVC()
            }
        }
        
        tradingPortFilterVC.tradeType = tradeType
        tradingPortFilterVC.hsCodeSearchText = hsCodeSearchText
        tradingPortFilterVC.tradeAreaSearchText = tradeAreaSearchText
        tradingPortFilterVC.tradingPortSearchText = tradingPortSearchText
    
        present(tradingPortFilterVC, animated: false)
    }
    
    
    // MARK: - Custom Actions
    @IBAction func backTapped(_ sender: UIButton) {
        //        navigationController?.popViewController(animated: true)
        dismiss(animated: false)
    }
    
    @IBAction func companyContactTapped(_ sender: UIButton) {
        moveToContactDetailVC()
    }
    
    @IBAction func filterTapped(_ sender: UIButton) {
        switch tradeFilterData[selectedIndex].title.getString(for: dataType).localizeString() {
        case "Trade Overview".localizeString():
            break
            
        case "Transaction Records".localizeString():
            openTransactionRecordSheet()
            
        case "Suppliers".getString(for: dataType).localizeString():
            openSupplierFilterSheet()
            
        case "HS Code".localizeString():
            openTradingFilterSheet(tradeType: .HSCode)
            
        case "Trade Area".localizeString():
            openTradingFilterSheet(tradeType: .TradeArea)
            
        case "Trading Ports".localizeString():
            openTradingFilterSheet(tradeType: .TradingPort)
            
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CompanyDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tradeFilterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tradeCollectionView.dequeueReusableCell(withReuseIdentifier: "TradeFilterCell", for: indexPath) as! TradeFilterCell
        
        let isCountZero = tradeFilterData[indexPath.row].count == 0
        let title = isCountZero ? tradeFilterData[indexPath.row].title : "\(tradeFilterData[indexPath.row].title) (\(tradeFilterData[indexPath.row].count))"
        cell.lblTitle.text = title.getString(for: dataType).localizeString()
        
        if tradeFilterData[indexPath.row].isSelected {
            cell.viewBack.backgroundColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            cell.lblTitle.textColor = UIColor.white
        } else {
            cell.viewBack.borderColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            cell.viewBack.borderWidth = 1
            cell.viewBack.backgroundColor = UIColor.white
            cell.lblTitle.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = tradeFilterData.firstIndex(where: { $0.isSelected == true }) {
            tradeFilterData[index].isSelected = false
        }
        tradeFilterData[indexPath.row].isSelected = true
        tradeCollectionView.reloadData()
        viewContent.subviews.forEach { $0.removeFromSuperview() }
        selectedIndex = indexPath.row
        switch tradeFilterData[indexPath.row].title.getString(for: dataType).localizeString() {
        case "Trade Overview".localizeString():
            if tradeCountData == nil {
                self.showLoader()
                companyTradeCountDetailVM.tradeCountDetailAPI(dataType: dataType, companyName: companyName)
            } else {
                moveToTradeOverviewVC()
            }
            
        case "Transaction Records".localizeString():
            if transactionRecordsData == nil {
                callTransactionRecordsAPI()
            } else {
                moveToTransactionsRecordsVC()
            }
            
        case "Suppliers".getString(for: dataType).localizeString():
            if supplierData == nil {
                self.showLoader()
                companyTradeCountDetailVM.companuyTradePartnerAPI(dataType: dataType, companyName: companyName)
            } else {
                moveToSupplierVC()
            }
            
        case "HS Code".localizeString():
            if hsCodeData == nil {
                self.showLoader()
                companyTradeCountDetailVM.companuyHSCodeAPI(dataType: dataType, companyName: companyName)
            } else {
                moveToHSCodeVC()
            }
            
        case "Trade Area".localizeString():
            if tradeAreaData == nil {
                self.showLoader()
                companyTradeCountDetailVM.companyTradingAreaAPI(dataType: dataType, companyName: companyName)
            } else {
                moveToTradeAreaVC()
            }
            
        case "Trading Ports".localizeString():
            if tradePortData == nil {
                self.showLoader()
                companyTradeCountDetailVM.companyTradePortAPI(dataType: dataType, companyName: companyName)
            } else {
                moveToTradingPortVC()
            }
            
        default:
            break
        }
    }
}

// MARK: - CompanyTradeCountDetailDelegate

// Trade Count Company Detail
extension CompanyDetailVC: CompanyTradeCountDetailDelegate {
    func didReceiveCompanyTradeCountDetailResponse(response: TradeCountModel?, error: String?) {
        hideLoader()
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                tradeCountData = response
                moveToTradeOverviewVC()
            } else {
                showAlert(message: error ?? "")
            }
        }
    }
}

// MARK: - Transaction Records API
extension CompanyDetailVC: CompanyListViewModelDelegate {
    func didReceiveProductResponse(response: CompanyListModel?, error: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.hideLoader()
        }
        isLoadingData = false
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                transactionRecordsData = response
                if (response?.lists?.count ?? 0) < self.pageCount {
                    self.noMoreData = true
                } else {
                    self.noMoreData = false
                }
                
                if currentPage == 1 {
                    transactionRecordsData?.lists?.removeAll()
                    transactionRecordsData = response
                    currentPage += 1
                } else {
                    transactionRecordsData?.lists?.append(contentsOf: response?.lists ?? [])
                    currentPage += 1
                }
                moveToTransactionsRecordsVC()
            } else {
                self.showAlert(message: error ?? "")
            }
            
        }
    }
}

// MARK: - Supplier API
// Trade Partner || Supplier API Response
extension CompanyDetailVC {
    func didReceiveCompanyTradePartnerResponse(response: TradePartnerModel?, error: String?) {
        self.hideLoader()
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                supplierData = response
                moveToSupplierVC()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
}


// MARK: - HS Code API
extension CompanyDetailVC {
    func didReceiveCompanyHSCodeResponse(response: HSCodeModel?, error: String?) {
        self.hideLoader()
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                hsCodeData = response
                moveToHSCodeVC()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
}

// MARK: - Trading Area API
extension CompanyDetailVC {
    func didReceiveCompanyTradingAreaResponse(response: TradeAreaModel?, error: String?) {
        self.hideLoader()
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                tradeAreaData = response
                moveToTradeAreaVC()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
}

// MARK: - Trading Area API
extension CompanyDetailVC {
    func didReceiveCompanyTradePortResponse(response: TradePortModel?, error: String?) {
        self.hideLoader()
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                tradePortData = response
                moveToTradingPortVC()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
}
