//
//  HSCodeVCTableViewCell.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/17/24.
//

import UIKit

class HSCodeTableCell: UITableViewCell {
    
    @IBOutlet weak var lblHSCodeTitle: UILabel!
    @IBOutlet weak var lblHSCodeSubTitle: UILabel!
    
    @IBOutlet weak var lblProportion: UILabel!
    @IBOutlet weak var lblNumOfTransactions: UILabel!
    @IBOutlet weak var lblNumOfTrasnactionsTitle: UILabel!
    @IBOutlet weak var lblProportionTitle: UILabel!
    
    var dataType: Int = 0
    var companyName: String = ""
    var vc: UIViewController?
    var importExportType: ImportExportType = .Import
    
    var selectedHSCode: TradeData?
    var selectedPort: Item?
    var selectedTradeArea: Item?
    
    var selectedOverViewState: OverViewStates?
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNumOfTrasnactionsTitle.text = "Number of transactions".localizeString()
        lblProportionTitle.text = "Proportion".localizeString()
    }
    
    func configureTradeAreaCell(obj: TradeAreaModel?, index: Int) {
        lblHSCodeTitle.text = "Region Name"
        guard let obj = obj else { return }
        selectedTradeArea = obj.items?[index]
        lblHSCodeSubTitle.text = (obj.items?[index].country ?? "").getCountryName()
        lblNumOfTransactions.text = "\(obj.baseInfo?.tradeTimes ?? 0)"
        lblProportion.text = vc?.calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: Double(obj.items?[index].count ?? 0))
    }
    
    func configureTradingPortCell(obj: TradePortModel?, index: Int) {
        lblHSCodeTitle.text = "Port Name".localizeString()
        guard let obj = obj else { return }
        selectedPort = obj.items?[index]
        lblHSCodeSubTitle.text = obj.items?[index].port ?? ""
        lblNumOfTransactions.text = "\(obj.baseInfo?.tradeTimes ?? 0)"
        lblProportion.text = vc?.calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: Double(obj.items?[index].count ?? 0))
    }
    
    func configureHSCodeCell(obj: HSCodeModel?, index: Int) {
        lblHSCodeTitle.text = "HS Code Name"
        guard let obj = obj else { return }
        selectedHSCode = obj.data?[index]
        lblHSCodeSubTitle.text = obj.data?[index].hsCode ?? ""
        lblNumOfTransactions.text = "\(obj.baseInfo?.tradeTimes ?? 0)"
        lblProportion.text = vc?.calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: Double(obj.data?[index].count ?? 0))
    }
    
    func moveToOverViewDetailVC(overViewState: OverViewStates, paramModel: CompanyListParamsModel?) {
        let overviewDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OverviewDetailVC") as! OverviewDetailVC
        overviewDetailVC.overViewState = overViewState
        overviewDetailVC.paramModel = paramModel
        overviewDetailVC.dataType = dataType
        overviewDetailVC.selectedImportExportType = importExportType
        overviewDetailVC.modalPresentationStyle = .overFullScreen
        vc?.present(overviewDetailVC, animated: false)
    }
    
    
    @IBAction func cellTapped(_ sender: UIButton) {
        switch selectedOverViewState {
        case .TransactionOverview:
            break
        case .TradeRecords:
            break
        case .Supplier:
            break
        case .HSCode:
            if selectedHSCode != nil {
                let hsCode = [selectedHSCode?.hsCode ?? ""]
                
                var obj = CompanyListParamsModel(dataType: dataType, page: 1, pageCount: 10, hsCode: hsCode)
                if dataType == 0 {
                    obj.buyer = companyName
                } else {
                    obj.supplier = companyName
                }
                moveToOverViewDetailVC(overViewState: .HSCode, paramModel: obj)
            }
        case .TradeArea:
            if selectedTradeArea != nil {
                var obj = CompanyListParamsModel(dataType: dataType, page: 1, pageCount: 10)
                if dataType == 0 {
                    obj.buyer = companyName
                    obj.buyerCountry = selectedTradeArea?.country ?? ""
                } else {
                    obj.supplier = companyName
                    obj.supplierCountry = selectedTradeArea?.country ?? ""
                }
                moveToOverViewDetailVC(overViewState: .TradeArea, paramModel: obj)
            }
        case .TradingPort:
            if selectedPort != nil {
                var obj = CompanyListParamsModel(dataType: dataType, page: 1, pageCount: 10)
                
                if dataType == 0 {
                    obj.buyer = companyName
                    obj.exportPort = selectedPort?.port ?? ""
                } else {
                    obj.supplier = companyName
                    obj.importPort = selectedPort?.port ?? ""
                }
                moveToOverViewDetailVC(overViewState: .TradingPort, paramModel: obj)
            }
        case nil:
            break
        }
    }
}
