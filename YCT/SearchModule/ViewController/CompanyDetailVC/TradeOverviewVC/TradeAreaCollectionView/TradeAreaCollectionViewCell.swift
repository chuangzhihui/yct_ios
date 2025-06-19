//
//  TradeAreaCollectionViewCell.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 12/5/24.
//

import UIKit

class TradeAreaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblProportion: UILabel!
    
    var vc: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(obj: TradeAreaModel?, index: Int) {
        guard let obj = obj else { return }
        imgFlag.image = (obj.items?[index].country ?? "").getCountryImage()
        lblCountryName.text = (obj.items?[index].country?.uppercased() ?? "")
        lblProportion.text = vc?.calculateProportion(total: obj.baseInfo?.tradeTimes ?? 0, value: Double(obj.items?[index].count ?? 0))
    }

}
