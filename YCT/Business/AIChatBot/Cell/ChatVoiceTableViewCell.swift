//
//  ChatVoiceTableViewCell.swift
//  YCT
//
//  Created by Fenris on 7/30/24.
//

import AVFoundation
import UIKit
import Photos

@available(iOS 13.0, *)
class ChatVoiceTableViewCell: UITableViewCell {
    @IBOutlet var sliderSender: UISlider!
    @IBOutlet var imgPlayPause: UIImageView!
    
    @IBOutlet var lblAudioDuraiton: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgPreview: UIImageView!
    @IBOutlet var viewImage: UIView!
    @IBOutlet var viewAudio: UIView!
    @IBOutlet var viewText: UIView!
    @IBOutlet var btnPlay: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var isRecordingPlay = false
    var cellData: ConversationInfo?
    var elapsedTime: TimeInterval = 0
    var audioPlayerCallBack: ((_ id: Int) -> Void)?
    var stopAudioRecordingCallBack: (() -> Void)?
    
    var audioDownloadCallBack: (() -> Void)?
    var audioData: Data?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureSender(_ cellData: ConversationInfo) {
        self.sliderSender.isUserInteractionEnabled = false
        self.cellData = cellData
        self.lblAudioDuraiton.text = ""
        if let thumbImage = UIImage(named: "sliderThumb") {
            self.sliderSender.setThumbImage(thumbImage, for: .normal)
        }
        let audioUrl = ServiceUrls.audioUrl + cellData.message
        self.downloadVoice(url: audioUrl)
        
        if let currentAudio = Global.shared.currentAudioPlayer, currentAudio.isPlaying, cellData.isAudioPlaying {
            self.imgPlayPause.image = UIImage(systemName: "pause")
        } else {
            if let cellData = self.cellData,(cellData.isVoiceDownloaded) {
                self.imgPlayPause.image = UIImage(systemName: "play")
            } else {
                self.imgPlayPause.image = UIImage(named: "download")
            }
        }
        self.btnPlay.setTitle(" ", for: .normal)
    }
    
    
    //self.audioUrl
    func downloadVoice(url:String){
        self.downloadAudio(from: URL(string: url)!) { audioData in
            if let audioData = audioData {
                self.audioData = audioData
            }
        }
    }
    
    func preparePlayer(from data: Data) {
        DispatchQueue.main.async { [self] in
            var error: NSError?
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                self.audioPlayer = try AVAudioPlayer(data: data)
                self.sliderSender.minimumValue = 0
                self.sliderSender.maximumValue = Float(self.audioPlayer!.duration)
                self.lblAudioDuraiton.text = String(format: "%.2f", Float(self.audioPlayer!.duration))
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                if let audioPlayer = self.audioPlayer {
                    Global.shared.currentAudioPlayer = audioPlayer
                }
                self.audioFlageSwitch(isPlaying: true)
                self.audioPlayer?.play()
            } catch {
                print("Failed to play audio: \(error.localizedDescription)")
                self.audioPlayer = AVAudioPlayer()
            }
            
            if let err = error {
                print("AVAudioPlayer error: \(err.localizedDescription)")
            } else {
                self.audioPlayer?.delegate = self
                self.audioPlayer?.prepareToPlay()
            }
        }
    }
    
    @objc func updateTime(_ timer: Timer) {
        if let audioPlayer = self.audioPlayer {
            self.sliderSender.value = Float(audioPlayer.currentTime)
        }
    }
    
    func pauseAudio() {
        self.audioPlayer?.pause()
        self.stopTimer()
    }
    
    func getAudioDuration(from url: URL) -> TimeInterval? {
        let asset = AVURLAsset(url: url)
        let audioDuration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(audioDuration).rounded(.up)
        
        return durationInSeconds.isFinite ? durationInSeconds : nil
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        let formattedString = formatter.string(from: timeInterval)
        return formattedString ?? ""
    }
    
    @IBAction func actionPlayPauseSender(_ sender: UIButton) {
        if let cellData = self.cellData,!(cellData.isVoiceDownloaded) {
            let audioUrl = ServiceUrls.audioUrl + cellData.message
            DispatchQueue.main.async {
                sender.showLoader()
            }
            self.saveVoice(from: URL(string: audioUrl)!) { isSavel in
                if let callBack = self.audioDownloadCallBack{
                    callBack()
                    DispatchQueue.main.async {
                        self.btnPlay.setTitle(" ", for: .normal)
                        self.imgPlayPause.image = UIImage(systemName: "play")
                        cellData.saveVoiceDownloaded(isDownload: true)
                        sender.hideLoader()
                    }
                }
            }
        } else {
            self.playPauseAudio()
        }
    }
    
    @IBAction func senderSlide(_ slider: UISlider) {
        self.audioPlayer!.currentTime = TimeInterval(slider.value)
    }
    
    func playPauseAudio() {
        if !(self.isRecordingPlay) {
            self.stopCurrentAudio()
            self.isRecordingPlay = true
            self.imgPlayPause.image = UIImage(systemName: "pause")
            if let callBack = self.stopAudioRecordingCallBack {
                callBack()
            }
            if let data = self.cellData {
                if let audio = self.audioData {
                    self.preparePlayer(from: audio)
                } else {
                    let audioUrl = ServiceUrls.audioUrl + data.message
                    self.downloadAudio(from: URL(string: audioUrl)!) { audioData in
                        if let audioData = audioData {
                            // Play the audio
                            self.preparePlayer(from: audioData)
                        }
                    }
                }
            }
        } else {
            Global.shared.currentAudioPlayer?.stop()
            Global.shared.currentAudioPlayer = nil
            Global.shared.CurrentAudioIndex = -1
            if let data = self.cellData {
                data.isAudioPlaying = false
            }
            self.isRecordingPlay = false
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            self.imgPlayPause.image = UIImage(systemName: "play")
        }
    }
}

extension ChatVoiceTableViewCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Stop the timer when audio playback finishes
        self.imgPlayPause.image = UIImage(systemName: "play")
        self.stopTimer()
        self.isRecordingPlay = false
    }
    
    func downloadAudio(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to download audio: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received while downloading audio.")
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
        
    func saveVoice(from url: URL, completion: @escaping (Bool) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to download audio: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received while downloading audio.")
                completion(false)
                return
            }
            completion(true)
            // Save the downloaded data to a file in the Documents directory
            let fileManager = FileManager.default
            do {
                // Get the documents directory URL
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // Create a unique file name based on the URL's last path component or other identifier
                let fileName = url.lastPathComponent
                
                // Create a file URL in the documents directory
                let fileURL = documentsURL.appendingPathComponent(fileName)
                
                // Write the data to the file
                try data.write(to: fileURL)
                
                print("Audio saved successfully at \(fileURL)")
                self.shareFile(at: fileURL)
                
                
            } catch {
                print("Failed to save audio file: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    func shareFile(at url: URL) {
        DispatchQueue.main.async {
            if let viewController = self.parentViewController() {
                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = viewController.view
                viewController.present(activityViewController, animated: true, completion: nil)
            } else {
                print("Parent view controller not found")
            }
        }
    }
    
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.sliderSender.setValue(0.0, animated: true)
        self.audioFlageSwitch(isPlaying: false)
    }
    
    func stopCurrentAudio() {
        if let currentAudio = Global.shared.currentAudioPlayer {
            currentAudio.stop()
            self.audioFlageSwitch(isPlaying: false)
        }
    }
    
    func audioFlageSwitch(isPlaying: Bool) {
        if let cellData = self.cellData {
            cellData.isAudioPlaying = isPlaying
            if isPlaying {
                if let callBack = self.audioPlayerCallBack {
                    callBack(1)
                }
            } else {
                if let callBack = self.audioPlayerCallBack {
                    callBack(2)
                }
            }
        }
    }
}
