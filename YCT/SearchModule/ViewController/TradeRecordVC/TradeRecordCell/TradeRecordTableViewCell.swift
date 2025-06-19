//
//  TradeRecordTableViewCell.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/10/24.
//

import UIKit

class TradeRecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblBuyerTitle: UILabel!
    @IBOutlet weak var lblSupplierTitle: UILabel!
    @IBOutlet weak var lblTradingProductsTitle: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBuyerDescrip: UILabel!
    @IBOutlet weak var lblSupplierDescrip: UILabel!
    @IBOutlet weak var lblProducts: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var lblWeightTitle: UILabel!
    
    var superVc:UIViewController?
    var companyDetailVM: CompanyDetailViewModel = CompanyDetailViewModel()
    var companyDetailData: CompanyDetailModel?
    
    // MARK: - Variable & Constants
    var touchDataType: Int = 0
    var dataType: Int = 0
    var vc: UIViewController?
    var importExportType: ImportExportType = .Import
    var list: List?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        companyDetailVM.delegate = self
    }
    
    func configureOverViewHSCell(obj: List?) {
        viewWeight.isHidden = true
        guard let obj = obj else { return }
        list = obj
        viewWeight.isHidden = true
        lblBuyerTitle.text = "Quantity".localizeString()
        lblSupplierTitle.text = "Supplier".getString(for: dataType).localizeString()
        lblTradingProductsTitle.text = "Trading Products".localizeString()
        lblProducts.text = obj.products ?? ""
        lblBuyerDescrip.text = "\(obj.quantity ?? 0.0)"
        
        lblSupplierDescrip.text = dataType == 0 ? obj.tradeCorporate ?? "" : obj.corporate ?? ""
    }
    
    func configureOverViewTradePortDetails(obj: List?) {
        viewWeight.isHidden = true
        guard let obj = obj else { return }
        list = obj
        lblSupplierTitle.text = "Quantity".localizeString()
        lblBuyerTitle.text = "Supplier".getString(for: dataType).localizeString()
        lblTradingProductsTitle.text = "Trading Products".localizeString()
        lblBuyerDescrip.text = dataType == 0 ? obj.tradeCorporate ?? "" : obj.corporate ?? ""
        lblSupplierDescrip.text = "\(obj.quantity ?? 0.0)"
        lblProducts.text = obj.products ?? ""
    }
    
    func configureOverViewTradeAreaDetails(obj: List?) {
        viewWeight.isHidden = true
        guard let obj = obj else { return }
        list = obj
        lblSupplierTitle.text = "Quantity".localizeString()
        lblBuyerTitle.text = "Supplier".getString(for: dataType).localizeString()
        lblTradingProductsTitle.text = "Trading Products".localizeString()
        lblBuyerDescrip.text = dataType == 0 ? obj.tradeCorporate ?? "" : obj.corporate ?? ""
        lblSupplierDescrip.text = "\(obj.quantity ?? 0.0)"
        lblProducts.text = obj.products ?? ""
    }
    
    func configureTradeRecordCell(obj: List?) {
        viewWeight.isHidden = false
        guard let obj = obj else { return }
        list = obj
        lblDate.text = obj.accTime?.convertSecondsToDateString()
        lblWeightTitle.text = "Weight".localizeString()
        lblSupplierTitle.text = "Supplier".localizeString()
        lblBuyerTitle.text = "Buyer".localizeString()
        lblTradingProductsTitle.text = "Trading Products".localizeString()
        
        let corporateText = (obj.corporate ?? "").colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
        let countryText = NSAttributedString(string: ", " + (obj.country ?? "").getCountryName(), attributes: [.foregroundColor: UIColor.black])
        let buyerDescription = NSMutableAttributedString()
        buyerDescription.append(corporateText)
        buyerDescription.append(countryText)
        lblBuyerDescrip.attributedText = buyerDescription
        
        let tradeCorporate = (obj.tradeCorporate ?? "").colored(with: UIColor.hexStringToUIColor(hex: "#022EA9"))
        let tradecountryText = NSAttributedString(string: ", " + (obj.tradeCountry ?? "").getCountryName(), attributes: [.foregroundColor: UIColor.black])
        let supplierDescription = NSMutableAttributedString()
        supplierDescription.append(tradeCorporate)
        supplierDescription.append(tradecountryText)
        lblSupplierDescrip.attributedText = supplierDescription
        
        lblWeight.text = "\((obj.weight ?? 0.0))" + (obj.weightUnit ?? "")
        lblProducts.text = obj.products ?? ""
        contentView.layoutIfNeeded()
    }
    
    func moveTradeRecordDetailVC() {
        let tradeRecordDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TradeRecordDetailVC") as! TradeRecordDetailVC
        
        tradeRecordDetailVC.selectedImportExportType = importExportType
        tradeRecordDetailVC.dataType = dataType
        tradeRecordDetailVC.isFromOverview = true
        tradeRecordDetailVC.tradeID = list?.id
        
        tradeRecordDetailVC.modalPresentationStyle = .overFullScreen
        vc?.present(tradeRecordDetailVC, animated: false)
    }
    
    func moveToCompanyDetailVC(companyName: String, dataType: Int) {
        let companyDetailVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "CompanyDetailVC") as! CompanyDetailVC
        companyDetailVC.modalPresentationStyle = .overFullScreen
        companyDetailVC.companyName = companyName
        companyDetailVC.dataType = dataType
        companyDetailVC.importExportType = importExportType
        vc?.present(companyDetailVC, animated: false)
    }

    func comopanyDetailAPI(id:String, dataType:Int) {
        companyDetailVM.comopanyDetailAPI(tradeID: id, dataType: dataType)
    }
    
    @IBAction func cellTapped(_ sender: UIButton) {
//        moveTradeRecordDetailVC()
        touchDataType = 0;
        comopanyDetailAPI(id: list?.id ?? "", dataType: dataType)
    }
    
    @IBAction func buyerTapped(_ sender: UIButton) {
//        moveToCompanyDetailVC(companyName: list?.corporate ?? "", dataType: 0)
        touchDataType = 1;
        comopanyDetailAPI(id: list?.id ?? "", dataType: dataType)
    }
    
    @IBAction func supplierTapped(_ sender: UIButton) {
//        moveToCompanyDetailVC(companyName: list?.tradeCorporate ?? "", dataType: 1)
        touchDataType = 2;
        comopanyDetailAPI(id: list?.id ?? "", dataType: dataType)
    }
}

extension TradeRecordTableViewCell: CompanyDetailViewModelDelegate {
    func didReceiveDetailResponse(response: CompanyDetailModel?, error: String?) {
        if error == nil && response == nil {
            vc?.moveToPaymentVC()
        } else {
            if error == nil {
                if touchDataType == 0 {
                    moveTradeRecordDetailVC()
                } else if (touchDataType == 1) {
                    moveToCompanyDetailVC(companyName: list?.corporate ?? "", dataType: 0)
                } else if (touchDataType == 2) {
                    moveToCompanyDetailVC(companyName: list?.tradeCorporate ?? "", dataType: 1)
                }
            } else {
                vc?.showAlert(message: error ?? "")
            }
        }
    }
}
