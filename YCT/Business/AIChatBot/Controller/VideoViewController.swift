//
//  VideoViewController.swift
//  YCT
//
//  Created by Noman Umar on 07/08/2024.
//

import UIKit
import AVKit
import AVFoundation
import Photos
import UGCKit
class VideoViewController: BaseViewController {

    
    @IBOutlet var videoView: UIView!
    @IBOutlet var btnUpload: UIButton!
    
    let playerController = AVPlayerViewController()
    fileprivate var player: AVPlayer! { playerController.player }
    fileprivate var asset: AVAsset!
    var id = ""
    var videoLink = ""
    var buttonType = 1
    var downloadedVideoPath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoView.hide()
        self.btnUpload.hide()
        self.btnUpload.setTitle("Download", for: .normal)
        self.buttonType = 1
        self.showIndicator(withTitle: "it take about 3 minutes to\ngenerate the video")

        self.apiCallForGenerateVideo()
        // Do any additional setup after loading the view.
    }
    
    
    func configureVideo(){
        videoView.clipsToBounds = true
        self.videoView.show()
        self.btnUpload.show()
        playVideo()
    }
    
    private func playVideo() {
        // Your Code
        // Rotate view for landscape recoded view
        // Rotate View on the bases of video orientation
        
        asset = AVAsset(url: (URL(string: videoLink))!)
        playerController.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        videoView.addSubview(playerController.view)
        videoView.layer.cornerRadius = 10
        playerController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerController.view.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
            playerController.view.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            playerController.view.topAnchor.constraint(equalTo: videoView.topAnchor),
            playerController.view.widthAnchor.constraint(equalTo: videoView.widthAnchor),
            playerController.view.heightAnchor.constraint(equalTo: videoView.safeAreaLayoutGuide.heightAnchor)
        ])
        
        player.play()
    }
    
    func saveVideo() {
        self.showIndicator(withTitle: "downloading...")
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: self.videoLink),
               let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let filePath = "\(documentsPath)/" + "yct".randomString(length: 8) + ".mp4"
                // Save data to file and add video to photo library on background thread
                DispatchQueue.global(qos: .background).async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        DispatchQueue.main.async {
                            if completed {
                                self.downloadedVideoPath = filePath
                                self.hideIndicator()
                                self.btnUpload.setTitle("Upload", for: .normal)
                                self.buttonType = 2
                            }
                        }
                    }
                }
            }
        }
    }

    
    
    //YCTPublishViewController
    func moveToPublishViewController() {
        // Initialize UGCKitMedia with the video path
        let media = UGCKitMedia(videoPath: downloadedVideoPath)

        // Initialize UGCKitResult with the media
        let result = UGCKitResult()
        result.media = media
        result.code = 0 // Set the appropriate code, if needed
        
        // Initialize YCTPublishViewController with the result
        let publish = YCTPublishViewController(ugcKitResult: result)
        publish.isFromVideoView = true
        publish.filePath = downloadedVideoPath
        
        // Push to navigation stack
        if let nav = navigationController {
            var viewControllers = nav.viewControllers
            viewControllers.removeAll()
            viewControllers.append(publish)
            nav.setViewControllers(viewControllers, animated: true)
        }
    }
    
    @IBAction func actionPopBack(_ sender: UIButton) {
        self.popBackToParentVC()
    }
    
    @IBAction func actionUpload(_ sender: UIButton) {
        if self.buttonType == 1 {
            self.saveVideo()
        } else if self.buttonType == 2{
            self.moveToPublishViewController()
        }
    }
}

extension VideoViewController {
    
    func apiCallForGenerateVideo(progress:String = "0"){
        let param = ["video_id":self.id] as [String : Any]
        
        ServiceManager.shared.PostRequestWithHeaderVideo(url: ServiceUrls.URLs.getCurrentVideoResult, parameters: param) { response in
            if let res = response as? NSDictionary {
                if let code = res["code"] as? Int,code == 999 {
                    self.alertWithMessage("Please register/login first")
                } else if let data = res["data"] as? NSDictionary {
                    let status = data["status"] as? String  ?? ""
                    let progress = data["progress"] as? Double  ?? 0.0
                    
                    if status.lowercased() == "failed" || status.lowercased() == "fail" || status.lowercased() == "error" {
                        self.hideIndicator()
                        self.alertWithMessage("Something went wrong")
                    } else if status.lowercased() == "done" && progress >= 1.0 {
                        self.hideIndicator()
                        self.videoLink = data["video_output"] as? String ?? ""
                        self.configureVideo()
                    }  else if status.lowercased() != "done" && progress <= 1.0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                            self.apiCallForGenerateVideo()
                        })
                    }
                }  else if let msgString = res["msg"] as? String {
                    self.hideIndicator()
                    self.alertWithMessage(msgString)
                }
            }
        } failure: { error in
            self.hideIndicator()
            self.alertWithMessage(error.message)
        }
    }
}
