//
//  Global.swift
//  YCT
//
//  Created by Fenris on 7/30/24.
//

import Foundation
import AVFAudio
class Global {
    class var shared : Global {
        
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    
    var currentAudioPlayer: AVAudioPlayer?
    var CurrentAudioIndex = -1
}
