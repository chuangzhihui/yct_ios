//
//  SettingLiveRoomViewModel.swift
//  YCT
//
//  Created by Lucky on 16/03/2024.
//

import Foundation
import UIKit
import SendbirdLiveSDK

extension SendbirdLiveSDK.LiveEventType: CaseIterable {
    public static var allCases: [LiveEventType] = [.video, .audioOnly]
    
    func getText() -> String {
        switch self {
        case .video:
            return "Video"
        case .audioOnly:
            return "Audio Only"
        @unknown default:
            return "Video"
        }
    }
}

@objc class YCTSettingLiveRoomViewModel: NSObject {

    var liveCategories: [String] {
        return LiveStream.liveCategories
    }
    private(set) var selectedLiveCategory: Int = 0

    private(set) var liveMethod: [SendbirdLiveSDK.LiveEventType] = SendbirdLiveSDK.LiveEventType.allCases
    private(set) var selectedLiveMethod: Int = 0

    private let liveStreamManager: LiveStreamManager

    @objc init(liveStreamManager: LiveStreamManager) {
        self.liveStreamManager = liveStreamManager
        super.init()
    }

}

extension YCTSettingLiveRoomViewModel {
    func getLiveCategory(_ index: Int) -> String {
        self.selectedLiveCategory = index
        return self.liveCategories[index]
    }

    func getLiveMethod(_ index: Int) -> String {
        self.selectedLiveMethod = index
        return self.liveMethod[index].getText()
    }

    func createLiveStream(title: String,
                          category: String,
                          introduction: String,
                          coverImage: UIImage,
                          onComplete: @escaping (String?, Error?) -> Void) {
        uploadImage(image: coverImage) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let url):
                self.liveStreamManager.createChannel { [weak self] result in
                    guard let self else { return }

                    switch result {
                    case .success(let channel):
                        self.liveStreamManager.createLiveStream(
                            title: title,
                            category: category,
                            introduction: introduction,
                            liveMethod: self.liveMethod[self.selectedLiveMethod],
                            coverURL: url,
                            chatChannel: channel.channelURL,
                            onComplete: onComplete
                        )
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func uploadImage(image: UIImage, 
                             completion: @escaping (Result<String, Error>) -> Void) {
        YCTApiUpload(image: image).doStart { result in
            if let imageUrl = result?.url {
                completion(.success(imageUrl))
            } else {
                completion(.failure(AppError(message: "Unknown error")))
            }
        } failure: { errorStr in
            completion(.failure(AppError(message: errorStr)))
        }

    }
}
