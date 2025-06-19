//
//  ConversationSenderTableViewCell.swift
//  YCT
//
//  Created by Fenris on 7/19/24.
//

import UIKit

class ConversationSenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var imgPreview : UIImageView!
    @IBOutlet weak var viewImage : UIView!
    @IBOutlet weak var viewAudio : UIView!
    @IBOutlet weak var viewText : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(_ cellData:ConversationInfo){ //ConversationsMessageInfo
//        self.imgProfile.image = downloadImage(url: cellData., placeholder: "")//UIImage(named: "placeholderUser")
        print(cellData.message)
        self.lblTime.text = Date().stringDateWithTime()
        lblMessage.text = (cellData.message)
        cellData.isImage ? viewImage.show() : viewImage.hide()
        cellData.isAudio ? viewAudio.show() : viewAudio.hide()
        cellData.isAudio ? (viewText.hide()) : (viewText.show())
//        self.lblTime.text = ""
    }

}
