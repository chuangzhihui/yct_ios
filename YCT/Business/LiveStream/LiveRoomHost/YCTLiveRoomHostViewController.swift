//
//  YCTLiveRoomHostViewController.swift
//  YCT
//
//  Created by Lucky on 17/03/2024.
//

import UIKit
import SendbirdLiveSDK
import SVProgressHUD
import SendbirdChatSDK

class YCTLiveRoomHostViewController: YCTSwiftBaseViewController {
    @IBOutlet weak var viewLiveStream: UIView!
    @IBOutlet weak var viewContainer: UIView!

    @IBOutlet weak var lblLiveTitle: UILabel!
    @IBOutlet weak var lblParticipantCount: UILabel!
    @IBOutlet weak var lblLiveIntroduction: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var switchCameraButton: UIButton! {
        didSet {
            switchCameraButton.add(.touchUpInside) { [unowned self] _ in
                viewModel.liveEvent?.switchCamera()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.register(cellClass: MessageCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
        }
    }

    let viewModel: YCTLiveRoomHostViewModel
    private var groupChannel: OpenChannel?
    private var baseMessages = [BaseMessage]()
    var collection: MessageCollection?
    
    // MARK: - Constructors
    @objc init(viewModel: YCTLiveRoomHostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-share"), style: .plain, target: self, action: #selector(self.shareLiveRoom))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let groupChannel {
            LiveStreamManager.shared.removeChannelCallback(channel: groupChannel)
        }
        self.viewModel.endLiveEvent(completion: nil)
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLiveEvent()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }

}

extension YCTLiveRoomHostViewController {
    @objc func shareLiveRoom() {
       print("Share Live Room")
    }

    @IBAction func liveSettingActionTap(_ sender: UIButton) {
    }

    @IBAction func uploadProductActionTap(_ sender: UIButton) {
        let vc = UploadProductViewController()
        self.present(vc, animated: true)
    }

    @IBAction func openProductListActionTap(_ sender: UIButton) {
        let vc = HostProductListViewController()
        self.present(vc, animated: true)
    }
    
    @IBAction func sendMessageActionTap(_ sender: UIButton) {
        guard let groupChannel else {
            return
        }
        if let text = messageTextField.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty {
            messageTextField.text = ""
            LiveStreamManager.shared.sendMessage(text, to: groupChannel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let message):
                    if let message {
                        self.baseMessages.append(message)
                        self.tableView.reloadData {
                            self.tableView.scrollToBottom()
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
    }

    @IBAction func closeLiveEventActionTap(_ sender: UIButton) {
        let actionSheet = UIAlertController(
            title: "End live event?",
            message: "Select actions below",
            preferredStyle: .actionSheet
        )

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
          print("tap cancel")
        }))

        actionSheet.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { action in
            self.viewModel.endLiveEvent { [weak self] error in
                guard let self else { return }
                if let error = error {
                    self.view.showToast(error.localizedDescription, position: .center)
                } else {
                    DispatchQueue.main.async {
                        self.goBack()
                    }
                }
            }
        }))

        self.present(actionSheet, animated: true, completion: nil)
    }

    func getLiveEvent() {
        SVProgressHUD.show()
        self.viewModel.getLiveEvent { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(liveEvent):
                self.viewModel.enterLiveEvent(liveEvent) { [weak self] error in
                    guard let self else { return }
                    SVProgressHUD.dismiss()

                    if let error = error {
                        DispatchQueue.main.async {
                            self.view.showToast(error.localizedDescription, position: .center)
                        }
                    } else {
                        self.joinChannel(liveEvent: liveEvent)
                        liveEvent.addDelegate(self, forKey: liveEvent.userIdsForHost.first ?? "")
                        DispatchQueue.main.async {
                            self.setupLiveEventView(liveEvent)
                            self.updateLiveEventInfo(liveEvent)
                        }
                    }
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                self.view.showToast(error.localizedDescription, position: .center)
            }
        }
    }

    func setupLiveEventView(_ liveEvent: LiveEvent) {
        let sendbirdVideoView = SendbirdVideoView(frame: self.viewLiveStream.bounds,
                                                  contentMode: .scaleAspectFill)
        sendbirdVideoView.backgroundColor = UIColor(white: 44.0 / 255.0, alpha: 1.0)
        self.viewLiveStream.addSubview(sendbirdVideoView)
        self.viewLiveStream.sendSubviewToBack(sendbirdVideoView)

        liveEvent.setVideoViewForLiveEvent(view: sendbirdVideoView, hostId: liveEvent.hosts.first?.hostId ?? "")
        self.view.layoutIfNeeded()
    }

    func updateLiveEventInfo(_ liveEvent: LiveEvent) {
        let customItems = liveEvent.customItems
        let category = customItems["category"]
        DispatchQueue.main.async {
            self.lblLiveTitle.text = liveEvent.title ?? "Live Event"
            self.lblLiveIntroduction.text = category
        }
    }

    func startDurationTimer() {

    }
    
    private func joinChannel(liveEvent: LiveEvent) {
        if let channel = liveEvent.customItems["channel"] {
            
            LiveStreamManager.shared.joinChannel(channelUrl: channel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let channel):
                    self.groupChannel = channel
                    self.getAllMessage(completion: { [weak self] in
                        self?.subscribeChannelMessage()
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getAllMessage(completion: (() -> Void)?) {
        guard let groupChannel else {
            completion?()
            return
        }
        LiveStreamManager.shared.getAllMessage(of: groupChannel) { [weak self] list in
            guard let self else { return }
            self.baseMessages.removeAll()
            self.baseMessages.append(contentsOf: list)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData {
                    self?.tableView.scrollToBottom()
                }
            }
            completion?()
        }
    }
    
    private func subscribeChannelMessage() {
        guard let groupChannel else {
            return
        }
        LiveStreamManager.shared.addChannelCallback(channel: groupChannel) { [weak self] message in
            guard let self else { return }
            self.baseMessages.append(message)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData {
                    self?.tableView.scrollToBottom()
                }
            }

        }
    }
}

extension YCTLiveRoomHostViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: MessageCell.self, forIndexPath: indexPath)
        let message = baseMessages.get(indexPath.row)
        cell.label.text = "\(message?.sender?.nickname ?? ""): \(message?.message ?? "")"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


extension YCTLiveRoomHostViewController: LiveEventDelegate {
    func didHostVideoResolutionChange(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host, resolution: SendbirdLiveSDK.Resolution) {
        
    }
    
    func didParticipantCountChange(_ liveEvent: SendbirdLiveSDK.LiveEvent, participantCountInfo: SendbirdLiveSDK.ParticipantCountInfo) {
        DispatchQueue.main.async { [weak self] in
            self?.lblParticipantCount.text = "\(participantCountInfo.participantCount)"
        }
    }
    
    func didParticipantEnter(_ liveEvent: SendbirdLiveSDK.LiveEvent, participant: SendbirdLiveSDK.Participant) {
        print("didParticipantEnter = \(liveEvent.participantCount)")
    }

    func didParticipantExit(_ liveEvent: SendbirdLiveSDK.LiveEvent, participant: SendbirdLiveSDK.Participant) {

    }

    func didHostMuteAudioInput(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        //        updateHostCell(for: host.hostId)
        print("didHostMuteAudioInput")
    }

    func didHostUnmuteAudioInput(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        //        updateHostCell(for: host.hostId)
        print("didHostUnmuteAudioInput")
    }

    func didHostStartVideo(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        //        updateHostCell(for: host.hostId)
        print("didHostStartVideo")
    }

    func didHostStopVideo(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostStopVideo")
    }

    func didHostEnter(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostEnter")
    }

    func didHostExit(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostExit")
    }

    func didHostConnect(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostConnect")
    }

    func didHostDisconnect(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostDisconnect")
    }

    func didLiveEventReady(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        updateLiveEventInfo(liveEvent)
        print("didLiveEventReady")
    }

    func didLiveEventStart(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        DispatchQueue.main.async {
            self.startDurationTimer()
            print("didLiveEventStart")
        }
    }

    func didLiveEventEnd(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        print("didLiveEventEnd")
//        guard liveEvent.endedBy != SendbirdLive.currentUser?.userId else { return }
//        SBUAlertView.show(
//            title: "Live Event has ended",
//            confirmButtonItem: .init(title: "Okay", completionHandler: { _ in
//                DispatchQueue.main.async {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }),
//            cancelButtonItem: nil
//        )
    }

    func didLiveEventInfoUpdate(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        updateLiveEventInfo(liveEvent)
        print("didLiveEventInfoUpdate")
    }

    func didExit(_ liveEvent: SendbirdLiveSDK.LiveEvent, error: Error) {
        print("didExit")
        DispatchQueue.main.async {  [weak self] in
            guard let self else { return }
            self.view.makeToast("You have been disconnected from the Live Event", position: .bottom) { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func didDisconnect(_ liveEvent: LiveEvent, error: Error) {
        print("didDisconnect")
    }

    func didReconnect(_ liveEvent: LiveEvent) {
        print("didReconnect")
    }

    func didUpdateCustomItems(_ liveEvent: SendbirdLiveSDK.LiveEvent, customItems: [String: String], updatedKeys: [String]) {
        print("didUpdateCustomItems")
    }

    func didDeleteCustomItems(_ liveEvent: SendbirdLiveSDK.LiveEvent, customItems: [String: String], deletedKeys: [String]) {
        print("didDeleteCustomItems")
    }

    func didReactionCountUpdate(_ liveEvent: SendbirdLiveSDK.LiveEvent, key: String, value: Int) {
        print("didReactionCountUpdate")
    }
}
