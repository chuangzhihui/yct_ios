//
//  LiveStreamManager.swift
//  YCT
//
//  Created by Tan Vo on 02/01/2024.
//

import UIKit
import SendbirdChatSDK
import SendbirdLiveSDK

@objc class LiveStreamManager: NSObject {
    typealias ChannelCallback = ((BaseMessage) -> Void)
    static let didLoginNotificationName = Notification.Name("didLoginNotificationName")
    
    @objc static let shared = LiveStreamManager()

    @objc func initLivestream() {
        print("initLivestream")
        let appId = "301F3D17-B920-4DFE-8252-24EED9978C62"
        SendbirdChat.initialize(params: .init(applicationId: appId))
        SendbirdLive.initialize(params: .init(applicationId: appId, logLevel: .debug))
    }
    
    private let channelDelegateId = UUID().uuidString
    private var channelCallbacks: [String: ChannelCallback] = [:]
    
    var userId: String?
    private override init() {
        super.init()
        
    }

    @objc func loginUser(userId: String, onSuccess: @escaping ((User) -> Void), onFailure: @escaping ((Error) -> Void)) {
        print("loginUser")
        SendbirdChat.connect(userId: userId) { [unowned self] user, error in
            SendbirdChat.addChannelDelegate(self, identifier: self.channelDelegateId)
        }

        SendbirdLive.authenticate(userId: userId) { [unowned self] results in
            switch results {
            case .success(let user):
                self.userId = user.id
                print(user.id)
                onSuccess(user)
                NotificationCenter.default.post(name: Self.didLoginNotificationName, object: nil)
            case .failure(let error):
                print("Error connecting to Sendbird: \(error.localizedDescription)")
                onFailure(error)
            }
        }
    }
    
    @objc func logoutUser() {
        SendbirdLive.deauthenticate {
            // Log out
            self.userId = nil
        }
        SendbirdChat.removeAllChannelDelegates()
    }
    
    func createChannel(completion: ((Result<OpenChannel, Error>) -> Void)?) {
        let params = OpenChannelCreateParams()
        params.name = SendbirdLive.currentUser?.nickname
        params.coverURL = SendbirdLive.currentUser?.profileURL
        
        OpenChannel.createChannel(params: params) { channel, error in
            if let error = error {
                print("Error createChannel \(error.localizedDescription)")
                completion?(.failure(error))
                return
            }
            print("createChannel chanel Id: \(channel?.name)")
            if let channel = channel {
                completion?(.success(channel))
            }
        }
    }
    
    func joinChannel(channelUrl: String, completion: @escaping (Result<OpenChannel, Error>) -> Void) {
        OpenChannel.getChannel(url: channelUrl) { channel, error in
            if let channel {
                channel.enter { error in
                    if let error {
                        completion(.failure(error))
                    } else {
                        completion(.success(channel))
                    }
                }
            } else {
                completion(.failure(error ?? AppError(message: "Unknown error")))
            }
        }
    }

    func sendMessage(_ message: String,
                     to channel: OpenChannel?,
                     completion: ((Result<UserMessage?, Error>) -> Void)?) {
        let params = UserMessageCreateParams(message: message)
        params.mentionType = .users
        params.pushNotificationDeliveryOption = .default
        channel?.sendUserMessage(params: params) { userMessage, error in
            if let error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else  {
                completion?(.success(userMessage))
            }
        }
    }

    func getAllMessage(of channel: OpenChannel?, completion: (([BaseMessage]) -> Void)?) {
        let params = MessageListParams()
        params.previousResultSize = 100
        params.nextResultSize = 100
        params.includeThreadInfo = true
        params.messageTypeFilter = .all
        params.isInclusive = true
        
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        channel?.getMessagesByTimestamp(currentTime, params: params) { messages, error in
            guard error == nil else {
                return
            }
            let messages = messages ?? []
            print("Message count \(messages.count)")
            completion?(messages)
        }
    }

    func createLiveStream(title: String,
                          category: String,
                          introduction: String,
                          liveMethod: SendbirdLiveSDK.LiveEventType,
                          coverURL: String,
                          chatChannel: String,
                          onComplete: @escaping ((String?, Error?) -> Void)) {
        guard let userId else {
            onComplete(nil, AppError(message: "Please login"))
            return
        }
        let customItems: [String: String] = [
            "category": category,
            "introduction": introduction,
            "channel": chatChannel
        ]

        let params = LiveEvent.CreateParams(
            type: liveMethod,
            title: title,
            coverURL: coverURL,
            userIdsForHost: [userId], 
            customItems: customItems
        )
        SendbirdLive.createLiveEvent(config: params) { result in
            switch result {
            case .success(let liveEvent):
                print("liveEvent.liveEventId \(liveEvent.liveEventId) liveEvent.state \(liveEvent.state)")
                onComplete(liveEvent.liveEventId, nil)
            case .failure(let error):
                print("Error createLiveEvent to Sendbird \(error.localizedDescription)")
                onComplete(nil, error)
            }
        }
    }

    private func _enterLiveAsHost(liveEvent: LiveEvent, completion: @escaping (() -> Void)) {
        let mediaOptions = MediaOptions(turnVideoOn: true, turnAudioOn: true)
        liveEvent.enterAsHost(options: mediaOptions) { error in
            if let error {
                print("Enter live host error \(error.localizedDescription)")
            } else {
                if liveEvent.state == .created {
                    liveEvent.setEventReady()
                }
                liveEvent.startStreaming(mediaOptions: mediaOptions)
            }
            completion()
        }
    }


    private func _enterLive(liveEvent: LiveEvent, completion: @escaping (() -> Void)) {
        liveEvent.enter { error in
            if let error {
                print("Enter live error \(error.localizedDescription)")
            } else {
                if liveEvent.state == .created {
                    liveEvent.setEventReady()
                }
            }
            
            completion()
        }
    }

    func getLiveEventList(createdDateLastLive: Int64,
                          limit: Int = 20,
                          completion: @escaping ((Result<[LiveEvent], Error>) -> Void)) {
        var params = LiveEventListQueryParams()
        params.createdAtRange = 0..<createdDateLastLive
        params.limit = limit
        SendbirdLive.createLiveEventListQuery(params: params)
            .next { liveEvents, error in
                if let error {
                    print("Error getLiveEventList \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    completion(.success(liveEvents ?? []))
                }
            }
    }

    func enterLiveEvent(_ liveEvent: LiveEvent, completion: @escaping ((_ isHost: Bool) -> Void)) {
        if liveEvent.userIdsForHost.contains(where: { $0 == userId }) {
            _enterLiveAsHost(liveEvent: liveEvent, completion: {
                completion(true)
            })
        } else {
            _enterLive(liveEvent: liveEvent, completion: {
                completion(false)
            })
        }
    }
    
    func exitLiveEvent(_ liveEvent: LiveEvent, completion: ((Bool) -> Void)? = nil) {
        if liveEvent.userIdsForHost.contains(where: { $0 == userId }) {
            liveEvent.exitAsHost { error in
                if let error {
                    completion?(false)
                    print("Exit room error: \(error.localizedDescription)")
                } else {
                    completion?(true)
                    print("Exit success")
                }
            }
        } else {
            liveEvent.exit { error in
                if let error {
                    completion?(false)
                    print("Exit room error: \(error.localizedDescription)")
                } else {
                    completion?(true)
                    print("Exit success")
                }
            }
        }
    }
    
    func endLiveEvent(_ liveEvent: LiveEvent, completion: ((Error?) -> Void)?) {
        liveEvent.endEvent { error in
            completion?(error)
        }
    }

    func logout(completion: @escaping (() -> Void)) {
        SendbirdLive.deauthenticate(completionHandler: completion)
    }
}

// MARK: - OpenChannelDelegate
extension LiveStreamManager: OpenChannelDelegate {
    func addChannelCallback(channel: OpenChannel, callback: @escaping ChannelCallback) {
        channelCallbacks[channel.id] = callback
    }
    
    func removeChannelCallback(channel: OpenChannel) {
        channelCallbacks[channel.id] = nil
    }
    
    func channel(_ channel: BaseChannel, didReceive message: BaseMessage) {
        if let channel = channel as? OpenChannel,
           let channelCallback = channelCallbacks[channel.id] {
            channelCallback(message)
        }
    }
}

extension LiveStreamManager {
    func getLiveEvent(with liveEventId: String, completion: @escaping LiveEventHandler) {
        SendbirdLive.getLiveEvent(id: liveEventId, completionHandler: completion)
    }
}
