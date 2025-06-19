//
//  TransactionsRecordsCell.swift
//  SendSms
//
//  Created by Ali Wadood on 11/18/24.
//

import UIKit

class TransactionsRecordsCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var lblHSCodeNameTitle: UILabel!
    @IBOutlet weak var lblProportionTitle: UILabel!
    @IBOutlet weak var lblNumOfTransactionsTitle: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHSCodeName: UILabel!
    @IBOutlet weak var lblProportion: UILabel!
    
    @IBOutlet weak var lblNumOfTransaction: UILabel!
    
    // MARK: - Variabel & Constants
    var vc: UIViewController?
    var importExportType: ImportExportType = .Import
    var dataType: Int = 0
    var list: List?
    var tradePartnerData: TradePartnerGraphData?
    var tradePartnerAllData: TradePartnerModel?
    var companyName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureTransactionRecordsCell(obj: List?) {
        guard let obj = obj else { return }
        list = obj
        lblHSCodeNameTitle.text = "Trade Area".localizeString()
        lblProportionTitle.text = "Quantity".localizeString()
        lblNumOfTransactionsTitle.text = "Trading Products".localizeString()
        
        lblDate.text = obj.accTime?.convertSecondsToDateString() ?? ""
        
        lblHSCodeName.text = (obj.tradeCountry ?? "").getCountryName()
        lblNumOfTransaction.text = obj.products ?? ""
        lblProportion.text = "\(obj.quantity ?? 0.0)"
    }
    
    func configureSupplierCell(obj: TradePartnerModel?, index: Int) {
        guard let obj = obj else { return }
        tradePartnerAllData = obj
        tradePartnerData = obj.data?[index]
        lblHSCodeNameTitle.text = "Number of transactions".localizeString()
        lblProportionTitle.text = "Proportion".localizeString()
        lblNumOfTransactionsTitle.text = "Supplier".getString(for: dataType).localizeString() + " " + "Name".localizeString()
        
        lblDate.text = Int(obj.data?[index].timeStamp ?? 0).convertSecondsToDateString()
        
        lblHSCodeName.text = "\(Int(obj.data?[index].count ?? 0))"
        lblNumOfTransaction.text = obj.data?[index].name ?? ""
        lblProportion.text = vc?.calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: obj.data?[index].count ?? 0.0)
    }
    
    func moveTradeRecordDetailVC() {
        let tradeRecordDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TradeRecordDetailVC") as! TradeRecordDetailVC
        var id: String = ""
        
        if list != nil {
            id = list?.id ?? ""
        }
        
        tradeRecordDetailVC.selectedImportExportType = importExportType
        tradeRecordDetailVC.tradeID = id
        tradeRecordDetailVC.isFromOverview = true
        tradeRecordDetailVC.dataType = dataType
        
        tradeRecordDetailVC.modalPresentationStyle = .overFullScreen
        vc?.present(tradeRecordDetailVC, animated: false)
    }
    
    func moveToSupplierDetailVC() {
        let supplierDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SupplierDetailVC") as! SupplierDetailVC
        
        supplierDetailVC.dataType = dataType
        supplierDetailVC.companyName = companyName
        supplierDetailVC.id = tradePartnerData?.id ?? ""
        supplierDetailVC.partnerName = tradePartnerData?.name ?? ""
        supplierDetailVC.proportion = vc?.calculateProportion(total: tradePartnerAllData?.baseInfo?.tradeTimes ?? 0, value: tradePartnerData?.count ?? 0.0) ?? ""
        supplierDetailVC.modalPresentationStyle = .overFullScreen
        vc?.present(supplierDetailVC, animated: false)
    }
    
    @IBAction func cellTapped(_ sender: UIButton) {
        if list != nil {
            moveTradeRecordDetailVC()
        }
        
        if tradePartnerData != nil {
            moveToSupplierDetailVC()
        }
    }
    
}
