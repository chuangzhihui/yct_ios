//
//  PaymentTableViewCell.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 12/13/24.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblPackName: UILabel!
    @IBOutlet weak var lblQueryCount: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var imgCircule: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(obj: PaymentModel) {
        lblPackName.text = obj.type.rawValue.localizeString()
        lblQueryCount.text = obj.type.queryCount().localizeString()
        lblDiscount.text = obj.type.discountString().localizeString()
        lblPoints.text = obj.credits + " " + "Points".localizeString()
        lblPrice.text = "$\(obj.price).00"
    }
    
}
