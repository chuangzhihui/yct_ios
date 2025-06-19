//
//  ConversationList.swift
//  YCT
//
//  Created by Fenris on 7/19/24.
//

import Foundation
class ConversationList {
    
    var roomId = 0
    var success = 1
    var data:[ConversationInfo] = []

    
    init(_ dictionary: AnyObject) {
        
        self.roomId = dictionary["roomId"] as? Int ?? 0
        self.success = dictionary["success"] as? Int ?? 0

        if let list = dictionary["data"] as? [AnyObject]
        {
            for obj in list{
                self.data.append(ConversationInfo(obj as! NSDictionary))
            }
        }
    }
}



class ConversationInfo {
    var isGif = false
    var isImage = false
    var isAudio = false
    var message = ""
    var sender = 0
    var time = ""   
    var isAudioPlaying = false
    var audioData : Data = Data()
    var image = UIImage()
    var filePath : URL = URL(fileURLWithPath: "")
    var imageDownloaded = false
    var isVoiceDownloaded = false
    init() {
        
    }
    init(_ dictionary: AnyObject) {
        
        self.isImage = dictionary["is_image"] as? Bool ?? false
        self.message = dictionary["message"] as? String ?? ""
        self.sender = dictionary["sender"] as? Int ?? 0
        self.time = dictionary["time"] as? String ?? ""

    }
    
    init(_ dictionary: AnyObject,message:String) {
        self.message = message
        self.sender = dictionary["sender"] as? Int ?? 0
    }
    
    init(_ message:String,senderId:Int) {
        self.message = message
        self.sender = senderId
    }
    
    init(_ message:String,senderId:Int,isImage:Int) {
        self.message = message
        self.sender = senderId
        self.isImage = false
    }
    
    func saveImgDownloaded(isDownload:Bool){
        self.imageDownloaded = isDownload
    }
    func saveVoiceDownloaded(isDownload:Bool){
        self.isVoiceDownloaded = isDownload
    }
    
}
