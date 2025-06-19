//
//  SettingLiveRoomViewController.swift
//  YCT
//
//  Created by Lucky on 16/03/2024.
//

import UIKit
import ZLPhotoBrowser
import SVProgressHUD

@objc class YCTSettingLiveRoomViewController: YCTSwiftBaseViewController {

    typealias LiveStreamCallback = ((String) -> Void)

    @IBOutlet weak var tfLiveTitle: UITextField!
    @IBOutlet weak var tfLiveCategory: UITextField!
    @IBOutlet weak var tfLiveIntroduction: UITextView!
    @IBOutlet weak var imgSelectLiveCategory: UIImageView!
    @IBOutlet weak var imgLiveCover: UIImageView!
    @IBOutlet weak var tfLiveType: UITextField!
    @IBOutlet weak var imgSelectLiveType: UIImageView!

    private var didCreateLiveStreamCallback: LiveStreamCallback?

    let viewModel: YCTSettingLiveRoomViewModel

    @objc init(viewModel: YCTSettingLiveRoomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "SETTING LIVE ROOM"
        self.tfLiveCategory.text = self.viewModel.getLiveCategory(self.viewModel.selectedLiveCategory)
        self.tfLiveType.text = self.viewModel.getLiveMethod(self.viewModel.selectedLiveMethod)
    }

    @objc func didCreateLiveStream(callback: LiveStreamCallback?) {
        didCreateLiveStreamCallback = callback
    }
}

extension YCTSettingLiveRoomViewController {

    @IBAction func selectLiveCategoryActionTap(_ sender: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Live Category", message: "")

        let pickerViewValues: [[String]] = [self.viewModel.liveCategories]
        let pickerViewSelectedValues: [PickerViewViewController.Index] = [(column: 0, row: self.viewModel.selectedLiveCategory)]

        alert.addPickerView(values: pickerViewValues, initialSelections: pickerViewSelectedValues) { [weak self] vc, picker, index, values in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tfLiveCategory.text = self.viewModel.getLiveCategory(index.row)
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }

    @IBAction func selectImageCoverActionTap(_ sender: UIButton) {
        ZLPhotoConfiguration.default()
            .maxSelectCount(1)
            .allowSelectVideo(false)
            .allowSelectLivePhoto(false)
            .allowEditImage(true)
            .allowEditVideo(false)
            .allowSelectGif(false)
            .allowSelectOriginal(false)

        /// Using this init method, you can continue editing the selected photo
        let ac = ZLPhotoPreviewSheet()

        ac.selectImageBlock = { [weak self] results, isOriginal in
            guard let `self` = self else { return }
            self.imgLiveCover.image = results.filter {$0.asset.mediaType == .image}.map { $0.image }.first
        }

        ac.showPhotoLibrary(sender: self)
    }

    @IBAction func selectLiveMethodActionTap(_ sender: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Live Method", message: "")

        let pickerViewValues: [[String]] = [self.viewModel.liveMethod.map{$0.getText()}]
        let pickerViewSelectedValues: [PickerViewViewController.Index] = [(column: 0, row: self.viewModel.selectedLiveMethod)]

        alert.addPickerView(values: pickerViewValues, initialSelections: pickerViewSelectedValues) { [weak self] vc, picker, index, values in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tfLiveType.text = self.viewModel.getLiveMethod(index.row)
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }

    @IBAction func startLiveActionTap(_ sender: UIButton) {
        guard let title = tfLiveTitle.text, title.isNotEmpty else {
            self.view.showToast("Please input live title", position: .bottom)
            return
        }
        guard let image = self.imgLiveCover.image else {
            view.showToast("Please upload the image", position: .bottom)
            return
        }
        SVProgressHUD.show()
        
        self.viewModel.createLiveStream(
            title: title,
            category: self.tfLiveCategory.text ?? "",
            introduction: self.tfLiveIntroduction.text ?? "",
            coverImage: image,
            onComplete: { [weak self] (liveEventId, error)  in
                SVProgressHUD.dismiss()
                guard let self else { return }
                if let error = error {
                    self.view.showToast(error.localizedDescription, position: .center)
                } else if let liveEventId = liveEventId {
                    DispatchQueue.main.async {
                        self.goBack(false)
                        self.didCreateLiveStreamCallback?(liveEventId)
                    }
                }
            })
    }
}
