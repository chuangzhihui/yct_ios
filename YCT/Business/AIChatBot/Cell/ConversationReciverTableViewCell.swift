//
//  ConversationReciverTableViewCell.swift
//  YCT
//
//  Created by Fenris on 7/19/24.
//

import AVFoundation
import Photos
import SDWebImage
import UIKit

class ConversationReciverTableViewCell: UITableViewCell {
    
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgPreview: UIImageView!
    @IBOutlet var viewImage: UIView!
    @IBOutlet var viewAudio: UIView!
    @IBOutlet var viewText: UIView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var viewImageDownload: UIView!
    
    var imageDownloadCallBack: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(_ cellData: ConversationInfo) {
        lblTime.text = Date().stringDateWithTime()
        viewImageDownload.hide()
        if cellData.isImage {
            imgPreview.downloadImage(url: cellData.message, placeholder: "") { image, _ in
                if let _ = image {
                    self.viewImageDownload.show()
                }
            }
            viewImage.show()
            viewAudio.hide()
            viewText.hide()
            
            if cellData.imageDownloaded {
                viewImageDownload.hide()
            }
        }
        else if cellData.isAudio {
            let audioUrl = ServiceUrls.audioUrl + cellData.message
            print(audioUrl)
            
            viewImage.hide()
            viewAudio.show()
            viewText.hide()
        }
        else {
            viewImage.hide()
            viewAudio.hide()
            viewText.show()
            lblMessage.text = (cellData.message)
        }
    }
    
    @IBAction func actionImage(_ sender: UIButton) {
        saveImageFromImageView(imgPreview,button: sender)
        if let callBack = imageDownloadCallBack {
            callBack()
        }
    }
    
    func saveImageFromImageView(_ imageView: UIImageView,button:UIButton) {
        DispatchQueue.main.async {
            button.showLoader()
        }
        guard let image = imageView.image else {
            print("No image found in the imageView")
            return
        }
        
        // Check the authorization status for the Photos Library
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                // Save the image to the Photos Library
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                // Hide loader and update UI on the main thread
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.viewImageDownload.hide()
                    button.hideLoader()
                })                
                print("Image saved successfully")
            case .denied, .restricted:
                print("Permission denied to save image to Photos Library")
            case .notDetermined:
                print("User has not yet decided if they want to grant access")
            default:
                print("Unknown status")
            }
        }
    }
}

extension UIImageView {
    func downloadImage(url: String, placeholder: String, completion: @escaping ((UIImage?, Error?) -> Void)) {
        // remove space if a url contains.
        let stringWithoutWhitespace = url.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        sd_imageIndicator = SDWebImageActivityIndicator.gray
        if placeholder == "" {
            sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: nil, options: [.refreshCached]) { image, error, _, _ in
                completion(image, error)
            }
        }
        else {
            sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage(named: placeholder), options: [.refreshCached]) { image, error, _, _ in
                completion(image, error)
            }
        }
    }
}
