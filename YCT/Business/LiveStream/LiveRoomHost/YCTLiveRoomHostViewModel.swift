//
//  YCTLiveRoomHostViewModel.swift
//  YCT
//
//  Created by Lucky on 17/03/2024.
//

import Foundation
import SendbirdLiveSDK
import SendbirdChatSDK

@objc class YCTLiveRoomHostViewModel: NSObject {
    private let liveStreamManager: LiveStreamManager
    private let liveEventId: String

    private(set) var liveEvent: LiveEvent?

    @objc init(liveStreamManager: LiveStreamManager, liveEventId: String) {
        self.liveStreamManager = liveStreamManager
        self.liveEventId = liveEventId
        super.init()
    }
}

extension YCTLiveRoomHostViewModel {
    func getLiveEvent(completion: @escaping LiveEventHandler) {
        self.liveStreamManager.getLiveEvent(with: self.liveEventId, completion: completion)
    }

    func updateLiveEvent(_ liveEvent: LiveEvent) {
        self.liveEvent = liveEvent

    }

    func enterLiveEvent(_ liveEvent: LiveEvent, completion: @escaping (Error?) -> Void) {
        self.liveEvent = liveEvent
        self.liveStreamManager.enterLiveEvent(liveEvent) { _ in
            if liveEvent.state == .ongoing {
                completion(nil)
            } else {
                // Start Live streaming
                liveEvent.startEvent(mediaOptions: nil) { error in
                    completion(error)
                }
            }
        }
    }

    func endLiveEvent(completion: ((Error?) -> Void)?) {
        guard let liveEvent else {
            completion?(nil)
            return
        }
        liveStreamManager.endLiveEvent(liveEvent, completion: completion)
    }
}
