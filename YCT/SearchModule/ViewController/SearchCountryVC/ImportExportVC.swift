//
//  ImportExportVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 30/11/2024.
//

import UIKit

enum ImportExportType: String {
    case Import = "Import Data"
    case Export = "Export Data"
    
    var getID: Int {
        switch self {
        case .Import:
            return 0
        case .Export:
            return 1
        }
    }
}

class ImportExportVC: UIViewController {
    
    @IBOutlet weak var lblImport: UILabel!
    @IBOutlet weak var lblExport: UILabel!
    
    var type: ImportExportType = .Import
    
    var tappedCallBack: ((_ type: ImportExportType) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblImport.text = "Import Data".localizeString()
        lblExport.text = "Export Data".localizeString()

        switch type {
        case .Export:
            lblExport.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            lblImport.textColor = UIColor.black
            
        case .Import:
            lblImport.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            lblExport.textColor = UIColor.black
        }
        
    }

    @IBAction func importTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.tappedCallBack?(.Import)
        }
    }
    
    @IBAction func exportTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.tappedCallBack?(.Export)
        }
    }
}
