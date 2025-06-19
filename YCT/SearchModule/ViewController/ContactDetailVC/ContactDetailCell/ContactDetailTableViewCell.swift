//
//  ContactDetailTableViewCell.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/21/24.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblContatcDetailsTitle: UILabel!
    @IBOutlet weak var lblContactTitle: UILabel!
    @IBOutlet weak var lblContatctPerson: UILabel!
    @IBOutlet weak var lblContactNum: UILabel!
    
    var vc: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(obj: ContactData?) {
        guard let obj = obj else { return }
        lblContatcDetailsTitle.text = "Contact Person/Position".localizeString()
        lblContactTitle.text = "Contact Details".localizeString()
        lblContatctPerson.text = (obj.name ?? "").checkString()
        lblContactNum.text = (obj.value ?? "").checkString()
    }
}
