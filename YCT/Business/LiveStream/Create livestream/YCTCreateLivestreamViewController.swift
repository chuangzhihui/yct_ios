//
//  YCTCreateLivestreamViewController.swift
//  YCT
//
//  Created by Tan Vo on 02/01/2024.
//

import UIKit
import SDWebImage

@objc class YCTCreateLivestreamViewController: UIViewController {
    
    @objc static func initWithStoryboard() -> YCTCreateLivestreamViewController {
        let viewController = UIStoryboard(name: "Livestream", bundle: nil).instantiateViewController(withIdentifier: "YCTCreateLivestreamViewController") as! YCTCreateLivestreamViewController
        return viewController
    }

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    private var didCreateLivestreamCallback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.isEnabled = false
        coverImage.sd_setImage(with: URL(string: "https://picsum.photos/id/237/300/200"))
    }
    
    func didCreateLivestream(callback: (() -> Void)?) {
        didCreateLivestreamCallback = callback
    }
    
    @IBAction func titleTextFieldEditingChanged(_ sender: UITextField) {
        createButton.isEnabled = (sender.text ?? "").isEmpty == false
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
//        LiveStreamManager.shared.createLivestream(fromVC: self, title: titleTextField.text!, coverURL: "https://picsum.photos/id/237/300/200")
//        LiveStreamManager.shared.createChannel(fromVC: self, title: "", coverURL: "")
//        LiveStreamManager.shared.getChannelList { channel in
//            channel?.join(completionHandler: { error in
//                print("Error join group \(error?.localizedDescription)")
////                LiveStreamManager.shared.sendMessage("test message", to: channel)
//                LiveStreamManager.shared.getAllMessage(of: channel)
//            })
        
//        LiveStreamManager.shared.createLivestream(title: titleTextField.text ?? "",
//                                                  coverURL: "https://picsum.photos/id/237/300/200") { [weak self] in
//            DispatchQueue.main.async {
//                self?.didCreateLivestreamCallback?()
//                self?.dismiss(animated: true)
//            }
//        }
    }
}
