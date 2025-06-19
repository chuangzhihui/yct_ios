//
//  GenerateVideoViewController.swift
//  YCT
//
//  Created by apple on 06/08/2024.
//

import UIKit
import Foundation
import MBProgressHUD

class GenerateVideoViewController: BaseViewController {
    
    @IBOutlet weak var imgStyle1: UIImageView!
    @IBOutlet weak var imgStyle2: UIImageView!
    @IBOutlet weak var imgStyle3: UIImageView!
    @IBOutlet weak var imgStyle4: UIImageView!
    @IBOutlet weak var imgStyle5: UIImageView!
    @IBOutlet weak var imgStyle6: UIImageView!
    
    
    @IBOutlet weak var tfWeblink: UITextField!
    @IBOutlet weak var tfTargetAudience: UITextField!
    @IBOutlet weak var tfLanguage: NoPasteTextField!
    
    @IBOutlet weak var viewProductNameTextField: UIView!
    @IBOutlet weak var viewProductNameTextView: UIView!
    @IBOutlet weak var lblProductNameTextField: UILabel!
    @IBOutlet weak var lblProductNameTextView: UILabel!
    @IBOutlet weak var tfProductName: NoPasteTextField!
    @IBOutlet weak var tvProductName: PlaceholderTextView!
    
    @IBOutlet weak var viewTfProductName: UIView!
    @IBOutlet weak var viewTVProductName: UIView!
    
    
    @IBOutlet weak var viewAspectRatio1: UIView!
    @IBOutlet weak var viewAspectRatio2: UIView!
    @IBOutlet weak var viewAspectRatio3: UIView!
    
    @IBOutlet weak var lblAspectRatio1: UILabel!
    @IBOutlet weak var lblAspectRatio2: UILabel!
    @IBOutlet weak var lblAspectRatio3: UILabel!
    
    @IBOutlet weak var viewVideoLength1: UIView!
    @IBOutlet weak var viewVideoLength2: UIView!
    @IBOutlet weak var viewVideoLength3: UIView!
    
    @IBOutlet weak var lblVideoLength1: UILabel!
    @IBOutlet weak var lblVideoLength2: UILabel!
    @IBOutlet weak var lblVideoLength3: UILabel!
    
    
    var aspectRatio:aspectRatio = .nineSixteen
    var scriptType:scriptType = .aI
    var videoLength:videoLength = .fifteenSec
    var imageStyle = ""
    
    let languagePicker = ToolbarPickerView()
    let productPicker = ToolbarPickerView()
    var languageCode = ""
    var productValue = ""
    
    let languagesArray:[String] = [
        "Arabic", "Bulgarian", "Czech", "Danish", "German", "Greek, Modern",
        "English", "Spanish, Castilian", "Finnish", "French", "Hindi",
        "Croatian", "Indonesian", "Italian", "Japanese", "Korean", "Malay",
        "Dutch", "Polish", "Portuguese", "Romanian, Moldavian, Moldovan",
        "Russian", "Slovak", "Swedish", "Tamil", "Tagalog", "Turkish",
        "Ukrainian", "Chinese"
    ]
    let languageCodes = [
        "ar", "bg", "cs", "da", "de", "el", "en", "es", "fi", "fr", "hi", "hr",
        "id", "it", "ja", "ko", "ms", "nl", "pl", "pt", "ro", "ru", "sk", "sv",
        "ta", "tl", "tr", "uk", "zh"
    ]
    
    let productNameArray:[String] = [
        "Discovery",
        "Don't Worry",
        "Emotional",
        "Gen Z",
        "Let Me Show You",
        "Motivational",
        "Music Starter",
        "Problem Solution",
        "Story Time"
    ]
    
    let productValueArray:[String] = [
        "DiscoveryWriter",
        "DontWorryWriter",
        "EmotionalWriter",
        "GenZWriter",
        "LetMeShowYouWriter",
        "MotivationalWriter",
        "NarrationWriter",
        "ProblemSolutionWriter",
        "StoryTimeWriter"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.configure()
        // Do any additional setup after loading the view.
    }
    
    func configure(){
        self.imgStyle1.image = UIImage(named: "style1")
        self.imgStyle2.image = UIImage(named: "style2")
        self.imgStyle3.image = UIImage(named: "style3")
        self.imgStyle4.image = UIImage(named: "style4")
        self.imgStyle5.image = UIImage(named: "style5")
        self.imgStyle6.image = UIImage(named: "style6")
        
        self.clearAspectRatio()
        self.setAspectRatio(aspectRatio: self.aspectRatio)
        
        self.clearVideoLength()
        self.setVideoLength(videoLength: self.videoLength)
        
        self.clearScript()
        self.setScript(scriptType: self.scriptType)
        self.setScriptView(scriptType: self.scriptType)
        
        self.clearImageSelection()
        
        tfLanguage.inputAccessoryView = languagePicker.toolbar
        tfLanguage.inputView = languagePicker
        languagePicker.dataSource = self
        languagePicker.delegate = self
        languagePicker.toolbarDelegate = self
        
        // Delegate for Pickerview and toolbar
        tfProductName.inputAccessoryView = productPicker.toolbar
        tfProductName.inputView = productPicker
        productPicker.dataSource = self
        productPicker.delegate = self
        productPicker.toolbarDelegate = self
        
    }
    
    
    func isValidURL(_ urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    
    func clearAspectRatio(){
        self.viewAspectRatio1.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        self.viewAspectRatio2.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        self.viewAspectRatio3.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        
        self.lblAspectRatio1.textColor = .black
        self.lblAspectRatio2.textColor = .black
        self.lblAspectRatio3.textColor = .black
    }
    
    func setAspectRatio(aspectRatio:aspectRatio){
        self.aspectRatio = aspectRatio
        switch aspectRatio {
        case .nineSixteen:
            self.viewAspectRatio1.backgroundColor = UIColor(hex: "#E106A4")
            self.lblAspectRatio1.textColor = .white
        case .sixteenNine:
            self.viewAspectRatio2.backgroundColor = UIColor(hex: "#E106A4")
            self.lblAspectRatio2.textColor = .white
        case .oneOne:
            self.viewAspectRatio3.backgroundColor = UIColor(hex: "#E106A4")
            self.lblAspectRatio3.textColor = .white
        }
    }
    
    func clearVideoLength(){
        self.viewVideoLength1.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        self.viewVideoLength2.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        self.viewVideoLength3.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        
        self.lblVideoLength1.textColor = .black
        self.lblVideoLength2.textColor = .black
        self.lblVideoLength3.textColor = .black
    }
    
    func setVideoLength(videoLength:videoLength){
        self.videoLength = videoLength
        switch videoLength {
        case .fifteenSec:
            self.viewVideoLength1.backgroundColor = UIColor(hex: "#E106A4")
            self.lblVideoLength1.textColor = .white
        case .thirtySec:
            self.viewVideoLength2.backgroundColor = UIColor(hex: "#E106A4")
            self.lblVideoLength2.textColor = .white
        case .sixtySec:
            self.viewVideoLength3.backgroundColor = UIColor(hex: "#E106A4")
            self.lblVideoLength3.textColor = .white
        }
    }
    
    func clearScript(){
        self.viewProductNameTextField.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        self.viewProductNameTextView.backgroundColor = UIColor(hex: "#E106A4")?.withAlphaComponent(0.3)
        
        self.lblProductNameTextField.textColor = .black
        self.lblProductNameTextView.textColor = .black
    }
    
    func setScript(scriptType:scriptType){
        self.scriptType = scriptType
        switch scriptType {
        case .aI:
            self.viewProductNameTextField.backgroundColor = UIColor(hex: "#E106A4")
            self.lblProductNameTextField.textColor = .white
        case .doItYourself:
            self.viewProductNameTextView.backgroundColor = UIColor(hex: "#E106A4")
            self.lblProductNameTextView.textColor = .white
        }
    }
    
    func setScriptView(scriptType:scriptType){
        switch scriptType {
        case .aI:
            self.viewTfProductName.show()
            self.viewTVProductName.hide()
        case .doItYourself:
            self.viewTfProductName.hide()
            self.viewTVProductName.show()
        }
    }
    
    
    func clearImageSelection(){
        self.imgStyle1.alpha = 1.0
        self.imgStyle2.alpha = 1.0
        self.imgStyle3.alpha = 1.0
        self.imgStyle4.alpha = 1.0
        self.imgStyle5.alpha = 1.0
        self.imgStyle6.alpha = 1.0
    }
    
    func setImageSelection(imageNumber:Int){
        
        switch imageNumber {
        case 1:
            self.imgStyle1.alpha = 0.5
            self.imageStyle = "FullScreenTemplate"
        case 2:
            self.imgStyle2.alpha = 0.5
            self.imageStyle = "GreenScreenEffectTemplate"
        case 3:
            self.imgStyle3.alpha = 0.5
            self.imageStyle = "QuickTransitionTemplate"
        case 4:
            self.imgStyle4.alpha = 0.5
            self.imageStyle = "OverCardsTemplate"
        case 5:
            self.imgStyle5.alpha = 0.5
            self.imageStyle = "AvatarBubbleTemplate"
        case 6:
            self.imgStyle6.alpha = 0.5
            self.imageStyle = "SideBySideTemplate"
        default:
            self.clearImageSelection()
        }
    }
    
    /** Validations for all text fields before api call */
    private func validations() -> Bool {
        var message = ""
        var isValidate = true
        
        if tfWeblink.text!.isEmpty {
            message = "Enter website link"
            isValidate = false
        } else if !(isValidURL(tfWeblink.text)) {
            message = "Enter valid website link"
            isValidate = false
        } else if tfLanguage.text!.isEmpty {
            message = "Select language"
            isValidate = false
        }  else if self.scriptType == .aI && tfProductName.text!.isEmpty {
            message = "Select product name"
            isValidate = false
        }   else if self.scriptType == .doItYourself && tvProductName.text!.isEmpty {
            message = "Enter product name"
            isValidate = false
        }    else if self.imageStyle.isEmpty {
            message = "Select visual style"
            isValidate = false
        }
        
        // if not validate show alert with message
        if !isValidate {
            alertWithMessage(message)
        }
        return isValidate
    }
    
    
    
    @IBAction func actionPopBack(_ sender: UIButton) {
        self.popBackToParentVC()
    }
    
    @IBAction func actionScript(_ sender: UIButton) {
        self.clearScript()
        if sender.tag == 1{
            self.setScript(scriptType: .aI)
            self.setScriptView(scriptType: .aI)
        } else if sender.tag == 2{
            self.setScript(scriptType: .doItYourself)
            self.setScriptView(scriptType: .doItYourself)
        }
    }
    
    @IBAction func actionAspectRatio(_ sender: UIButton) {
        self.clearAspectRatio()
        if sender.tag == 1{
            self.setAspectRatio(aspectRatio: .nineSixteen)
        } else if sender.tag == 2{
            self.setAspectRatio(aspectRatio: .sixteenNine)
        } else if sender.tag == 3{
            self.setAspectRatio(aspectRatio: .oneOne)
        }
    }
    
    @IBAction func actionVideoLength(_ sender: UIButton) {
        self.clearVideoLength()
        if sender.tag == 1{
            self.setVideoLength(videoLength: .fifteenSec)
        } else if sender.tag == 2{
            self.setVideoLength(videoLength: .thirtySec)
        } else if sender.tag == 3{
            self.setVideoLength(videoLength: .sixtySec)
        }
    }
    
    @IBAction func actionImageSelect(_ sender: UIButton) {
        self.clearImageSelection()
        self.setImageSelection(imageNumber: sender.tag)
    }
    
    @IBAction func actionNext(_ sender: UIButton) {
        if self.validations() {
            self.apiCallForGenerateLink()
        }
    }
}

extension GenerateVideoViewController {
    func apiCallForGenerateLink(){
        self.showIndicator(withTitle: "")
        let param = ["url":self.tfWeblink.text!]
        ServiceManager.shared.PostRequestWithHeaderVideo(url: ServiceUrls.URLs.generateLink, parameters: param) { response in
            if let data = response as? NSDictionary {
                if let code = data["code"] as? Int,code == 999 {
                    self.alertWithMessage("Please register/login first")
                } else if let msgData = data["data"] as? String {
                    self.apiCallForGenerateVideo(data: msgData)
                } else if let msgString = data["msg"] as? String {
                    self.hideIndicator()
                    self.alertWithMessage(msgString)
                }
            }
            print(response)
        } failure: { error in
            self.hideIndicator()
            self.alertWithMessage(error.message)
        }
    }
    
    func apiCallForGenerateVideo(data:String){
        self.showIndicator(withTitle: "")
        
        var targetAudience = self.tfTargetAudience.text!
        if self.tfTargetAudience.text!.isEmpty {
            targetAudience = "outdoor lover"
        }
        
        var scriptStyle = ""
        var overrideScript = ""
        if self.scriptType == .aI {
            scriptStyle = self.productValue
        } else if self.scriptType == .doItYourself {
            scriptStyle = "DIY"
            overrideScript = self.tvProductName.text!
        }
        
        let param = ["target_platform":self.tfWeblink.text!,
                     "target_audience":targetAudience,
                     "language":self.languageCode,
                     "video_length":self.videoLength.rawValue,
                     "aspect_ratio":self.aspectRatio.rawValue,
                     "script_style":scriptStyle,
                     "visual_style" : self.imageStyle,
                     "override_avatar" : "",
                     "override_voice" : "",
                     "override_script" : overrideScript,
                     "link" : data,
        ] as [String : Any]
        
        ServiceManager.shared.PostRequestWithHeaderVideo(url: ServiceUrls.URLs.generateVideo, parameters: param) { response in
            if let res = response as? NSDictionary {
                if let code = res["code"] as? Int,code == 999 {
                    self.alertWithMessage("Please register/login first")
                } else if let data = res["data"] as? NSDictionary {
                    if let id = data["id"] as? String {
                        self.hideIndicator()
                        self.moveToVideoScreen(id: id)
                    }
                }  else if let msgString = res["msg"] as? String {
                    self.hideIndicator()
                    self.alertWithMessage(msgString)
                }
            }
            self.hideIndicator()
            print(response)
        } failure: { error in
            self.hideIndicator()
            self.alertWithMessage(error.message)
        }
    }
    
    func moveToVideoScreen(id:String){
        // Create an instance of the new view controller
        let storyboard = UIStoryboard(name: "AIChatBot", bundle: nil)
        if let secondVC = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
            secondVC.id = id
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
    }
}


extension GenerateVideoViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        languagePicker.endEditing(true)
        view.endEditing(true)
        tfLanguage.resignFirstResponder()
    }
    
    func didTapCancel() {
        view.endEditing(true)
        tfLanguage.resignFirstResponder()
    }
}


// MARK: Extension PickerView

extension GenerateVideoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.languagePicker {
            return self.languagesArray.count
        } else  {
            return self.productNameArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.languagePicker {
            return self.languagesArray[row]
        } else  {
            return self.productNameArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.languagePicker {
            tfLanguage.text = self.languagesArray[row]
            languageCode = self.languageCodes[row]
        } else if pickerView == self.productPicker {
            tfProductName.text = self.productNameArray[row]
            productValue = self.productValueArray[row]
        }
    }
}


enum aspectRatio:String {
    case nineSixteen = "9x16"
    case sixteenNine = "16x9"
    case oneOne = "1x1"
}

enum videoLength:Int  {
    case fifteenSec = 15
    case thirtySec = 30
    case sixtySec = 60
}

enum scriptType {
    case aI
    case doItYourself
}
