//
//  SenderChatVoiceTableViewCell.swift
//  YCT
//
//  Created by Fenris on 8/1/24.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class SenderChatVoiceTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var sliderSender : UISlider!
    @IBOutlet weak var btnPlayPauseSender:UIButton!
    @IBOutlet weak var imgPlayPause:UIImageView!
    
    @IBOutlet weak var lblAudioDuraiton : UILabel!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var imgPreview : UIImageView!
    @IBOutlet weak var viewImage : UIView!
    @IBOutlet weak var viewAudio : UIView!
    @IBOutlet weak var viewText : UIView!

    
    

    
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var isRecordingPlay = false
    var cellData:ConversationInfo?
    var elapsedTime: TimeInterval = 0
    var audioPlayerCallBack : ((_ id:Int) -> Void)?
    var stopAudioRecordingCallBack : (() -> Void)?
    var audioData:Data?
    
    
    var recordingSession: AVAudioSession!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    func configureSender(_ cellData:ConversationInfo){
        self.sliderSender.isUserInteractionEnabled = false
        self.cellData = cellData
        lblAudioDuraiton.text = "0.2"
        if let thumbImage = UIImage(named: "sliderThumb") {
            sliderSender.setThumbImage(thumbImage, for: .normal)
        }
        let audioUrl = ServiceUrls.audioUrl + cellData.message
        print(audioUrl)
        self.audioData = cellData.audioData

        
        if let currentAudio = Global.shared.currentAudioPlayer,currentAudio.isPlaying,(cellData.isAudioPlaying){
//            self.btnPlayPauseSender.setImage(UIImage(named: "chat_pause"), for: .normal)
            
            self.imgPlayPause.image = UIImage(systemName: "pause")
            
        } else {
//            self.btnPlayPauseSender.setImage(UIImage(named: "chat_play"), for: .normal)
            self.imgPlayPause.image = UIImage(systemName: "play")
        }
            
        
        
    }
    
    func preparePlayer(url : URL) {
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            try recordingSession.setCategory(.playback)
            try recordingSession.setActive(true)
            audioPlayer?.play()
        } catch let error1 as NSError {
            error = error1
            audioPlayer = AVAudioPlayer()
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
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
                if let audioPlayer = self.audioPlayer{
                    Global.shared.currentAudioPlayer = (audioPlayer)
                }
                self.audioFlageSwitch(isPlaying: true)
                self.audioPlayer?.play()
            } catch  {
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
        if let audioPlayer = self.audioPlayer{
            self.sliderSender.value = Float(audioPlayer.currentTime)
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
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
    
    
    
    @IBAction func actionPlayPauseSender(_ sender : UIButton)
    {
        self.playPauseAudio()
    }
    
    @IBAction func senderSlide(_ slider: UISlider) {
        self.audioPlayer!.currentTime = TimeInterval(slider.value)
    }
    
    
    func playPauseAudio(){
        if !(self.isRecordingPlay){
            self.stopCurrentAudio()
            self.isRecordingPlay = true
            self.imgPlayPause.image = UIImage(systemName: "pause")
            if let callBack = self.stopAudioRecordingCallBack{
                callBack()
            }
            if let data = self.cellData{
                if let audio = self.audioData{
                    self.preparePlayer(from: audio)
                } else {
                    let audioUrl = ServiceUrls.audioUrl + data.message
                    self.downloadAudio(from: URL(string: audioUrl)!) { (audioData) in
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
            if let data = self.cellData{
                data.isAudioPlaying = false
            }
            self.isRecordingPlay = false
            audioPlayer?.stop()
            audioPlayer = nil
//            btnPlayPauseSender.setImage(UIImage(named: "chat_play"), for: .normal)
            self.imgPlayPause.image = UIImage(systemName: "play")
            
        }
    }
    
}

extension SenderChatVoiceTableViewCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Stop the timer when audio playback finishes
//        self.btnPlayPauseSender.setImage(UIImage(named: "chat_play"), for: .normal)
        self.imgPlayPause.image = UIImage(systemName: "play")
        self.stopTimer()
        self.isRecordingPlay = false
    }
    
    func downloadAudio(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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


    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.sliderSender.setValue(0.0, animated: true)
        self.audioFlageSwitch(isPlaying: false)
    }
    
    func stopCurrentAudio(){
        if let currentAudio = Global.shared.currentAudioPlayer{
            currentAudio.stop()
            self.audioFlageSwitch(isPlaying: false)
        }
    }
    
    func audioFlageSwitch(isPlaying:Bool){
        if let cellData = self.cellData{
            cellData.isAudioPlaying = isPlaying
            if isPlaying{
                if let callBack = self.audioPlayerCallBack{
                    callBack(1)
                }
            } else {
                if let callBack = self.audioPlayerCallBack{
                    callBack(2)
                }
            }
        }
    }
}
