//
//  ServiceUrl.swift
//  Motion2Coach
//
//  Created by nawaz on 1/24/23.
//

import Foundation

class ServiceUrls {
    
    //------------------------------------
    // MARK: BaseUrl
    //------------------------------------
    static var baseUrl: String {
        return "https://yct.vnppp.net/index/openai/"
//        return "http://54.226.28.219:8081/index/openai/"
    }

    static var baseUrlVideo: String {
        return "https://yct.vnppp.net/"
//        return "http://54.226.28.219:8081/"
    }
    
    static var audioUrl: String {
        return "https://yct.vnppp.net/download/"
//        return "http://54.226.28.219:8081/download/"
    }
    
    //------------------------------------
    // MARK: Api Urls
    //------------------------------------
    
    struct URLs {
        
        //*** Image Download
       
        //**Authentication  Urls**/
        static let textToText = "gpt-4-turbo-chat"
        static let textToImage = "textToImage"
        static let textToSpeech = "textToSpeech"
        static let imageToText = "imageToText"
        
        static let speechToText = "speechToText"
        static let generateLink = "index/video/generateLink"
        static let generateVideo = "index/video/generateVideo"
        static let getCurrentVideoResult = "index/video/getCurrentVideoResult"
        
    }
}
