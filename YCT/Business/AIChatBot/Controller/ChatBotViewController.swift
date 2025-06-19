//
//  ChatBotViewController.swift
//  YCT
//
//  Created by Fenris on 7/19/24.
//

import Alamofire
import AVFAudio
import MBProgressHUD
import UIKit

class ChatBotViewController: BaseViewController, ImagePickerDelegate {
    func imageDidSelect(image: UIImage?, imageUrl: URL?, imageExtension: String, imageName: String) {
        if let img = image {
            viewImagePreview.show()
            selectedImage.image = img
        }
    }
    
    //=======================================
    
    // MARK: Properties
    
    //=======================================
    
    // -----Views
    @IBOutlet var viewImagePreview: UIView!
    @IBOutlet var viewChatOptions: UIView!
    @IBOutlet var viewAudioRecording: UIView!
    // -----Labels
    
    // -----TextFields
    @IBOutlet var inputTextView: UITextView!
    // -----Buttons
    
    // -----Images
    @IBOutlet var imgMenuOption: UIImageView!
    @IBOutlet var selectedImage: UIImageView!
    @IBOutlet var imgRecording: UIImageView!
    // -----Others
    @IBOutlet var txtViewHeight: NSLayoutConstraint?
    @IBOutlet var tblConversation: UITableView!
    
    // # Public/Internal/Open
    
    // # Private/Fileprivate
    var messageList: [ConversationInfo] = []
    
    var lastDisplayedDate: Date?
    
    var imagePicker: ImagePicker!
    
    var isRecordingStart = false
    var msgType = RequestType.TextToText
    
    // For audio record
    var audioRecorder: AVAudioRecorder?
    var audioFilePath: URL?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    var voiceName = ""
    var isRecordingPlay = false
    var timer = Timer()
    //=======================================
    
    // MARK: Initilisers
    
    //=======================================
    
    //=======================================
    
    // MARK: View Lifecycle
    
    //=======================================
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    //=======================================
    
    // MARK: Configure
    
    //=======================================
    func configure() {
        inputTextView.text = "Please Input Message"
        inputTextView.textColor = UIColor.lightGray
        inputTextView.delegate = self
        
        viewChatOptions.dropShadow()
        
        tblConversation.delegate = self
        tblConversation.dataSource = self
        
        // Set row height to automatic dimension
        tblConversation.rowHeight = UITableView.automaticDimension
        // Set a default row height for performance
        tblConversation.estimatedRowHeight = 100
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        setupAudioSession()
    }
    
    //=======================================
    
    // MARK: Inherited Methods
    
    //=======================================
    
    //=======================================
    
    // MARK: Public Methods
    /// 自动填入输入框发送文本消息
    @objc var autoSendText:String? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[unowned self] in
                print("延迟执行的任务（主线程）")
                // 更新UI或其他主线程操作
                msgType = .TextToText
                inputTextView.text = autoSendText
                actionSendMessage(UIButton())
            }
        }
    }
    
    
    //=======================================
    
    //=======================================
    
    // MARK: Private Methods
    
    //=======================================
    
    /** Validations for all text fields before api call */
    func validations() -> Bool {
        var message = ""
        var isValidate = true
        
        // if not validate show alter with message
        if !isValidate {
            alertWithMessage(message)
        }
        
        return isValidate
    }
    
    func scrollToBottom(_ isAnimation: Bool = true) {
        if messageList.count > 0 {
            DispatchQueue.main.async {
                // self.conversationList.count
                let indexPath = IndexPath(row: self.messageList.count - 1, section: 0)
                self.tblConversation.scrollToRow(at: indexPath, at: .bottom, animated: isAnimation)
            }
        }
    }
    
    //=======================================
    
    // MARK: Action Methods
    
    //=======================================
    @IBAction func actionPopBack(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func actionShowHideOptions(_ sender: UIButton) {
        viewChatOptions.isHidden = !viewChatOptions.isHidden
    }
    
    @IBAction func actionMenuOptions(_ sender: UIButton) {
        viewAudioRecording.hide()
        if sender.tag == 1 {
            msgType = .TextToAudio
            imgMenuOption.image = UIImage(named: "textToAudio")
        }
        else if sender.tag == 2 {
            msgType = .ImageToText
            imgMenuOption.image = UIImage(named: "imageToText")
            imagePicker.present(from: sender)
        }
        else if sender.tag == 3 {
            msgType = .AudioToText
            view.endEditing(true)
            viewAudioRecording.show()
            imgMenuOption.image = UIImage(named: "audioToText")
        }
        else if sender.tag == 4 {
            msgType = .TextToImage
            // textToImage
            imgMenuOption.image = UIImage(named: "textToImage")
        }
        viewChatOptions.isHidden = !viewChatOptions.isHidden
    }
    
    @IBAction func actionHideAudioRecording(_ sender: UIButton) {
        msgType = .TextToText
        imgMenuOption.image = UIImage(named: "textToText")
        viewAudioRecording.hide()
    }
    
    @IBAction func actionStartStopRecording(_ sender: UIButton) {
        if !isRecordingStart {
            imgRecording.image = UIImage(named: "stopRecording")
            setupAudioSession()
            startRecording()
        }
        else {
            imgRecording.image = UIImage(named: "audioRecordingMic")
            finishRecording()
            actionSendMessage(sender)
        }
        isRecordingStart = !isRecordingStart
    }
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        viewImagePreview.hide()
        if msgType == .TextToText {
            sendMessageTextToText()
        }
        else if msgType == .TextToImage {
            sendMessageTextToImage()
        }
        else if msgType == .ImageToText {
            sendMessageImageToText()
        }
        else if msgType == .TextToAudio {
            sendMessageTextToAudio()
        }
        else if msgType == .AudioToText {
            addAudioToServer(filePath: getAudioFileURL())
        }
        
        inputTextView.textColor = UIColor.clear
        view.endEditing(true)
    }
    
    func convertAudioFileToData(at url: URL) -> Data? {
        do {
            let audioData = try Data(contentsOf: url)
            return audioData
        }
        catch {
            print("Failed to convert audio file to data: \(error.localizedDescription)")
            return nil
        }
    }
    
    @IBAction func actionSend(_ sender: UIButton) {}
    
    //=======================================
    
    // MARK: Protocol Methods
    
    //=======================================
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        print("Audio permission granted")
                    }
                    else {
                        print("Audio permission denied")
                    }
                }
            }
        }
        catch {
            // failed to record
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recordingSession = nil
        audioPlayer = nil
        do {
            // Set the audio session category to play and record with the speaker as the default output.
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            // failed to record
        }
    }
}

// MARK: Audio Delegate methods

extension ChatBotViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //        self.btnPlayPause.setImage(UIImage(named: "chat_play"), for: .normal)
        isRecordingPlay = false
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        }
        catch {
            // failed to record
        }
    }
    
    // MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func getMediaName() -> String {
        let name = "yct".randomString(length: 8) + ".m4a"
        return name
    }
    
    func getAudioFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(voiceName)
        return path as URL
    }
    
    func startRecording() {
        DispatchQueue.main.async {
            self.voiceName = self.getMediaName()
            let audioFilename = self.getAudioFileURL()
            let settings = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVEncoderBitRateKey: 128000, // Bit rate in bits per second (bps)
                AVNumberOfChannelsKey: 2, // Stereo audio
                AVSampleRateKey: 44100.0, //
            ] as [String: Any]
            
            do {
                self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                if let recoder = self.audioRecorder {
                    recoder.delegate = self
                    recoder.record()
                    // Start a timer to update the recording duration label
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                        guard let self = self else { return }
                        if recoder.isRecording {
                            let elapsedTime = recoder.currentTime
                        }
                    }
                }
            }
            catch {
                self.finishRecording()
            }
        }
    }
    
    func addAudioToServer(filePath: URL) {
        self.senderAudioToTextAppend(filePath: filePath)
        self.gifMessageAppend()
        
        
        let url = ServiceUrls.baseUrl + ServiceUrls.URLs.speechToText
        let userToken = YCTUserDataManager.sharedInstance().loginModel.token
        let headers: HTTPHeaders = [
            "token":  userToken.isEmpty ? ServiceManager.shared.token: userToken,
        ]
        // Use the correct URL in the multipartFormData
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(filePath, withName: "file", fileName: self.voiceName, mimeType: "audio/m4a")
            },
            to: url,
            headers: headers
        ).response { response in
            switch response.result {
            case .success(let data):
                if let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    print("Upload successful: \(json)")
                    if let data = json as? NSDictionary {
                        if let code = data["code"] as? Int,code == 999 {
                            self.messageList.removeLast(2)
                            self.tblConversation.reloadData()
                            self.alertWithMessage("Please register/login first")
                        } else if let dataResponse = data["data"] as? NSDictionary {
                            if let msgString = dataResponse["text"] as? String {
                                let msg = ConversationInfo()
                                msg.message = msgString
                                msg.sender = 2
                                self.messageList.removeLast()
                                self.messageList.append(msg)
                                self.tblConversation.reloadData()
                                self.setupAudioSession()
                                self.scrollToBottom()
                            }
                        } else {
                            self.messageList.removeLast(2)
                            self.tblConversation.reloadData()
                        }
                    }
                    print(response)
                    self.inputTextView.text = "Please Input Message"
                    self.inputTextView.textColor = UIColor.lightGray
                }
                else {
                    self.messageList.removeLast(2)
                    self.tblConversation.reloadData()
                    print("Upload successful but failed to parse response")
                }
                self.hideIndicator()
            case .failure(let error):
                self.messageList.removeLast(2)
                self.tblConversation.reloadData()
                print("Upload failed: \(error.localizedDescription)")
                self.inputTextView.text = "Please Input Message"
                self.inputTextView.textColor = UIColor.lightGray
                self.hideIndicator()
                self.alertWithMessage("Upload failed")
            }
        }
    }
    func senderAudioToTextAppend(filePath:URL){
        let sMsg = ConversationInfo()
        if let audioData = self.convertAudioFileToData(at: filePath) {
            sMsg.audioData = audioData
            sMsg.filePath = filePath
            sMsg.isAudio = true
        }
        sMsg.isImage = false
        sMsg.sender = 1
        self.messageList.append(sMsg)
    }
    
    func finishRecording() {
        timer.invalidate()
        audioRecorder?.stop()
        audioRecorder = nil
    }
}

//=======================================

// MARK: Extension

//=======================================

// MARK: Service Manager Api Calling

extension ChatBotViewController {
    func sendMessageTextToText() {
        self.senderTextMessageAppend()
        self.gifMessageAppend()
        let param = [
            "content": inputTextView.text!,
            "langType": 2,
            "role": "user",
            
        ] as [String: Any]
        ServiceManager.shared.PostRequestWithHeader(url: ServiceUrls.URLs.textToText, parameters: param) { 
            response in
            if let data = response as? NSDictionary {
                if let code = data["code"] as? Int,code == 999 {
                    self.messageList.removeLast(2)
                    self.tblConversation.reloadData()
                    self.alertWithMessage("Please register/login first")
                } else if let msgString = data["msg"] as? String {
                    if let msg = msgString.toDictionary() {
                        if let choices = msg["choices"] as? NSArray {
                            if choices.count > 0 {
                                if let messageDict = choices[0] as? NSDictionary {
                                    let finalJson = messageDict["message"] as? NSDictionary ?? NSDictionary()
                                    let finalMessage = finalJson["content"] as? String ?? ""
                                    print(finalMessage)
                                    let msg = ConversationInfo()
                                    msg.message = finalMessage
                                    msg.sender = 2
                                    self.messageList.removeLast()
                                    self.messageList.append(msg)
                                
                                    self.tblConversation.reloadData()
                                    self.scrollToBottom()
                                }
                            }
                        }
                    }
                }
            }
            self.inputTextView.text = "Please Input Message"
            self.inputTextView.textColor = UIColor.lightGray
            self.hideIndicator()
        } failure: { error in
            self.messageList.removeLast(2)
            self.tblConversation.reloadData()
            self.inputTextView.text = "Please Input Message"
            self.inputTextView.textColor = UIColor.lightGray
            self.hideIndicator()
            self.alertWithMessage(error.message)
        }
    }
    
    func senderTextMessageAppend(){
        let sMsg = ConversationInfo()
        sMsg.message = self.inputTextView.text == "Please Input Message" ? "" : self.inputTextView.text!
        sMsg.sender = 1
        sMsg.isAudio = false
        sMsg.isImage = false
        self.messageList.append(sMsg)
    }
    
    func gifMessageAppend(){
        let gifMsg = ConversationInfo()
        gifMsg.isGif = true
        gifMsg.sender = 2
        self.messageList.append(gifMsg)
        self.tblConversation.reloadData()
        self.scrollToBottom()
    }
    
    func sendMessageImageToText() {
        self.senderImageToTextAppend()
        self.gifMessageAppend()
        let compressData = selectedImage.image!.jpegData(compressionQuality: 0.2) // max value is 1.0 and minimum is 0.0
        let compressedImage = UIImage(data: compressData!)
        
        if let imageData = compressedImage!.pngData() {
            let strBase64: String = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            
            let param = [
                "content": inputTextView.text!,
                "imageURL": "data:image/jpeg;base64," + strBase64,
                
            ] as [String: Any]
            //            print(param)
            ServiceManager.shared.PostRequestWithHeader(url: ServiceUrls.URLs.imageToText, parameters: param) { response in
                
                if let data = response as? NSDictionary {
                    if let code = data["code"] as? Int,code == 999 {
                        self.messageList.removeLast(2)
                        self.tblConversation.reloadData()
                        self.alertWithMessage("Please register/login first")
                    } else if let msgString = data["msg"] as? String {
                        let msg = ConversationInfo()
                        msg.message = msgString
                        msg.sender = 2
                        self.messageList.removeLast()
                        self.messageList.append(msg)
                        self.tblConversation.reloadData()
                        self.scrollToBottom()
                    }
                }
                print(response)
                self.inputTextView.text = "Please Input Message"
                self.inputTextView.textColor = UIColor.lightGray
                self.hideIndicator()
            } failure: { error in
                self.messageList.removeLast(2)
                self.tblConversation.reloadData()
                self.inputTextView.text = "Please Input Message"
                self.inputTextView.textColor = UIColor.lightGray
                self.hideIndicator()
                self.alertWithMessage(error.message)
            }
        }
    }
    
    func senderImageToTextAppend(){
        let sMsg = ConversationInfo()
        sMsg.message = self.inputTextView.text == "Please Input Message" ? "" : self.inputTextView.text!
        sMsg.sender = 1
        sMsg.isAudio = false
        sMsg.isImage = true
        sMsg.image = self.selectedImage.image ?? UIImage()
        self.messageList.append(sMsg)
    }
    
    func sendMessageTextToImage() {
        self.senderTextToImageAppend()
        self.gifMessageAppend()
        let param = [
            "content": inputTextView.text!,
            
        ] as [String: Any]
        ServiceManager.shared.PostRequestWithHeader(url: ServiceUrls.URLs.textToImage, parameters: param) { response in
            
            if let data = response as? NSDictionary {
                if let code = data["code"] as? Int,code == 999 {
                    self.messageList.removeLast(2)
                    self.tblConversation.reloadData()
                    self.alertWithMessage("Please register/login first")
                } else if let msgString = data["msg"] as? String {
                    let msg = ConversationInfo()
                    msg.message = msgString
                    msg.isImage = true
                    msg.sender = 2
                    
                    self.messageList.removeLast()
                    self.messageList.append(msg)
                    
                    self.tblConversation.reloadData()
                    self.scrollToBottom()
                }
            }
            print(response)
            self.inputTextView.text = "Please Input Message"
            self.inputTextView.textColor = UIColor.lightGray
            self.hideIndicator()
        } failure: { error in
            self.messageList.removeLast(2)
            self.tblConversation.reloadData()
            self.inputTextView.text = "Please Input Message"
            self.inputTextView.textColor = UIColor.lightGray
            self.alertWithMessage(error.message)
            self.hideIndicator()
        }
    }
    
    func senderTextToImageAppend() {
        let sMsg = ConversationInfo()
        sMsg.message = self.inputTextView.text == "Please Input Message" ? "" : self.inputTextView.text!
        sMsg.sender = 1
        sMsg.isAudio = false
        sMsg.isImage = false
        self.messageList.append(sMsg)
    }
    func sendMessageTextToAudio() {
        self.senderTextToAudioAppend()
        self.gifMessageAppend()
        
        let param = [
            "content": inputTextView.text!,
            
        ] as [String: Any]
        ServiceManager.shared.PostRequestWithHeader(url: ServiceUrls.URLs.textToSpeech, parameters: param) { response in
            
            if let data = response as? NSDictionary {
                if let code = data["code"] as? Int,code == 999 {
                    self.messageList.removeLast(2)
                    self.tblConversation.reloadData()
                    self.alertWithMessage("Please register/login first")
                } else if let responseData = data["data"] as? NSDictionary {
                    if let body = responseData["body"] as? NSDictionary {
                        let filename = body["filename"] as? String ?? ""
                        let msg = ConversationInfo()
                        msg.message = filename
                        msg.isAudio = true
                        msg.sender = 2
                        self.messageList.removeLast()
                        self.messageList.append(msg)
                        self.tblConversation.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
            print(response)
            self.inputTextView.text = "Please Input Message"
            self.inputTextView.textColor = UIColor.lightGray
            self.hideIndicator()
        } failure: { error in
            self.messageList.removeLast(2)
            self.tblConversation.reloadData()
            self.inputTextView.text = "Please Input Message"
            self.inputTextView.textColor = UIColor.lightGray
            self.alertWithMessage(error.message)
            self.hideIndicator()
        }
    }
    func senderTextToAudioAppend(){
        let sMsg = ConversationInfo()
        sMsg.message = self.inputTextView.text == "Please Input Message" ? "" : self.inputTextView.text!
        sMsg.sender = 1
        sMsg.isAudio = false
        sMsg.isImage = false
        self.messageList.append(sMsg)
    }
}

extension ChatBotViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Input Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 1 {}
        else if textView.text.isEmpty {}
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        guard textView.contentSize.height < 100.0 else { textView.isScrollEnabled = true; return }
        textView.isScrollEnabled = false
        for constraint in textView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
                txtViewHeight!.constant = estimatedSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = "Please Input Message"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 10000
    }
}

// MARK: -

// MARK: - UITableViewDelegate & UITableViewDataSource Methods

// MARK: -

extension ChatBotViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension ChatBotViewController: UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = messageList[indexPath.row]
        if cellData.sender == 1 && !cellData.isAudio {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationSenderTableViewCell", for: indexPath) as! ConversationSenderTableViewCell
            cell.configure(cellData)
            cellData.isImage ? (cell.imgPreview.image = cellData.image) : (cell.imgPreview.image = UIImage())
            return cell
        }
        else if cellData.sender == 2 && cellData.isAudio {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatVoiceTableViewCell", for: indexPath) as! ChatVoiceTableViewCell
            cell.configureSender(cellData)
            cell.audioDownloadCallBack = {
                cellData.saveVoiceDownloaded(isDownload: true)
            }
            
            return cell
        }
        else if cellData.sender == 1 && cellData.isAudio {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatVoiceTableViewCell", for: indexPath) as! SenderChatVoiceTableViewCell
            cell.configureSender(cellData)
            
            return cell
        } else if cellData.isGif {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GifTableViewCell", for: indexPath) as! GifTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationReciverTableViewCell", for: indexPath) as! ConversationReciverTableViewCell
            cell.configure(cellData)
            cell.imageDownloadCallBack = {
                cellData.saveImgDownloaded(isDownload: true)
            }
            return cell
        }
    }
    
    func isCellVisible(at indexPath: IndexPath, in tableView: UITableView) -> Bool {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
            return false
        }
        return visibleIndexPaths.contains(indexPath)
    }
}

enum RequestType {
    case TextToText
    case TextToAudio
    case ImageToText
    case AudioToText
    case TextToImage
}

// MARK: General Method

extension String {
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
    func replaceString(fromString: String, toString: String) -> String {
        return replacingOccurrences(of: fromString, with: toString)
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
