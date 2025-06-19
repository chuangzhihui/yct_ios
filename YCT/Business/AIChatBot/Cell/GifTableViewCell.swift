//
//  GifTableViewCell.swift
//  YCT
//
//  Created by Noman Umar on 06/08/2024.
//

import UIKit
import UIKit
import ImageIO

class GifTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var gifImage : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.lblTime.text = Date().stringDateWithTime()
        
        if let gifPath = Bundle.main.path(forResource: "Gif", ofType: "gif"),
           let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)),
           let gifImage = UIImage.animatedImage(withAnimatedGIFData: gifData) {
            self.gifImage.image = gifImage
        }
        // Configure the view for the selected state
    }

    
}




extension UIImage {
    static func animatedImage(withAnimatedGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: Double = 0.0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
                
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any],
                   let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
                   let frameDuration = gifProperties[kCGImagePropertyGIFDelayTime] as? Double {
                    duration += frameDuration
                }
            }
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }
}
