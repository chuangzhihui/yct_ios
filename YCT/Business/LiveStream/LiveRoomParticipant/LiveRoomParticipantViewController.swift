//
//  LiveRoomParticipantViewController.swift
//  YCT
//
//  Created by Tan Vo on 02/01/2024.
//

import UIKit
import SendbirdLiveSDK
import AVKit
import SendbirdChatSDK
import FloatingPanel

class LiveRoomParticipantViewController: UIViewController {
    static func initWithStoryboard() -> LiveRoomParticipantViewController {
        let viewController = UIStoryboard(name: "Livestream", bundle: nil).instantiateViewController(withIdentifier: "LiveRoomParticipantViewController") as! LiveRoomParticipantViewController
        return viewController
    }
    
    var liveEvent: LiveEvent!
    
    private var groupChannel: OpenChannel?
    private var baseMessages = [BaseMessage]()
    
    private lazy var sendbirdVideoView: SendbirdVideoView = {
        let sendbirdVideoView = SendbirdVideoView(frame: .zero,
                                                  contentMode: .scaleAspectFill)
        sendbirdVideoView.backgroundColor = UIColor(white: 44.0 / 255.0, alpha: 1.0)
        return sendbirdVideoView
    }()
    @IBOutlet weak var videoLivestreamView: UIView!
    @IBOutlet var mediaControlView: UIView!
    @IBOutlet var closeFullscreenButton: UIButton! {
        didSet {
            closeFullscreenButton.isHidden = true
            closeFullscreenButton.add(.touchUpInside) { [unowned self] _ in
                closeFullscreenButton.isHidden = true
                mediaControlView.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.register(cellClass: MessageCell.self)
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBOutlet var hostNameLabel: UILabel! {
        didSet {
            hostNameLabel.textColor = .darkGray
        }
    }
    @IBOutlet var coverImageView: UIImageView!
    
    @IBOutlet var backButton: UIButton! {
        didSet {
            backButton.tintColor = .darkGray
            let image = UIImage(named: "navi_back")?.withRenderingMode(.alwaysTemplate)
            backButton.setImage(image,
                                for: .normal)
        }
    }
    @IBOutlet var participantCountLabel: UIButton! {
        didSet {
            participantCountLabel.titleLabel?.textColor = .darkGray
            participantCountLabel.tintColor = .darkGray
            let image = UIImage(named: "icon-members")?.withRenderingMode(.alwaysTemplate)
            participantCountLabel.setImage(image,
                                           for: .normal)
        }
    }
    @IBOutlet var moreButton: UIButton! {
        didSet {
            moreButton.tintColor = .darkGray
            moreButton.imageView?.tintColor = .darkGray
            let image = UIImage(named: "iconMore")?.withRenderingMode(.alwaysTemplate)
            moreButton.setImage(image,
                                for: .normal)
            moreButton.add(.touchUpInside) { [unowned self] _ in
                self.present(morePanel, animated: true, completion: nil)
            }
        }
    }
    private lazy var morePanel: FloatingPanelController = {
        let fpc = FloatingPanelController()
        let contentVC = LiveRoomParticipantMoreViewController()
        fpc.set(contentViewController: contentVC)
        fpc.layout = FixedHeightPanelLayout(height: 120)
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        contentVC.delegate = self
        return fpc
    }()
    
    @IBOutlet var productListButton: UIButton! {
        didSet {
            productListButton.add(.touchUpInside) { [unowned self] _ in
                guard let hostIdString = liveEvent.userIdsForHost.first, let hostId = Int(hostIdString) else {
                    return
                }
                let fpc = FloatingPanelController()
                let contentVC = ParticipantProductListViewController(hostId: hostId)
                fpc.set(contentViewController: contentVC)
                fpc.track(scrollView: contentVC.tableView)
                fpc.layout = FixedHeightPanelLayout(height: 350)
                fpc.isRemovalInteractionEnabled = true
                fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
                self.present(fpc, animated: true)
            }
        }
    }
    
    deinit {
        if let groupChannel {
            LiveStreamManager.shared.removeChannelCallback(channel: groupChannel)
        }
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func updateLiveEventInfo() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.hostNameLabel.text = self.liveEvent.title
            self.participantCountLabel.setTitle("\(self.liveEvent.participantCount)", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liveEvent.addDelegate(self, forKey: "SDFdsf")
        
        joinLiveEvent()
        joinChatChannel()
        
        
        
        self.videoLivestreamView.addSubview(sendbirdVideoView)
        sendbirdVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func joinLiveEvent() {
        LiveStreamManager.shared.enterLiveEvent(liveEvent) { isHost in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.liveEvent.setVideoViewForLiveEvent(view: self.sendbirdVideoView, hostId: self.liveEvent.hosts.first?.hostId ?? "")
                self.updateLiveEventInfo()
            }
        }
    }
    
    private func joinChatChannel() {
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
            guard let self else {
                return
            }
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
    
    private func initProductListPanel() -> FloatingPanelController? {
        guard let hostIdString = liveEvent.userIdsForHost.first, let hostId = Int(hostIdString) else {
            return nil
        }
        let fpc = FloatingPanelController()
        let contentVC = ParticipantProductListViewController(hostId: hostId)
        fpc.set(contentViewController: contentVC)
        fpc.layout = FixedHeightPanelLayout(height: 250)
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        return fpc
    }

    
}

// MARK: - Action selectors
extension LiveRoomParticipantViewController {
    @IBAction func exit(_ sender: Any) {
        LiveStreamManager.shared.exitLiveEvent(liveEvent)
        if let groupChannel {
            LiveStreamManager.shared.removeChannelCallback(channel: groupChannel)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func sendTappedAction(_ sender: UIButton) {
        guard let groupChannel else {
            return
        }
        LiveStreamManager.shared.sendMessage(messageTextField.text ?? "",
                                             to: groupChannel) { [weak self] result in
            guard let self else { return }
            self.messageTextField.text = ""
            switch result {
            case .success(let message):
                if let message {
                    self.baseMessages.append(message)
                    self.tableView.reloadData { [weak self] in
                        self?.tableView.scrollToBottom()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func toggleTranslucent(gesture: UITapGestureRecognizer) {
        mediaControlView.isHidden.toggle()
    }
}

extension LiveRoomParticipantViewController: LiveRoomParticipantMoreDelegate {
    func didTapFullscreen() {
        morePanel.dismiss(animated: true)
        mediaControlView.isHidden = true
        closeFullscreenButton.isHidden = false
    }
    
    func didTapShare() {
        morePanel.dismiss(animated: true)
        let activityViewController = UIActivityViewController(activityItems: [liveEvent.liveEventId],
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapReport() {
        
    }
}

extension LiveRoomParticipantViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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

extension LiveRoomParticipantViewController: LiveEventDelegate {
    func didHostVideoResolutionChange(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host, resolution: SendbirdLiveSDK.Resolution) {
        
    }
    
    func didParticipantCountChange(_ liveEvent: SendbirdLiveSDK.LiveEvent, participantCountInfo: SendbirdLiveSDK.ParticipantCountInfo) {
        DispatchQueue.main.async {
            self.participantCountLabel.setTitle("\(liveEvent.participantCount)", for: .normal)
        }
    }
    
    func didParticipantEnter(_ liveEvent: SendbirdLiveSDK.LiveEvent, participant: SendbirdLiveSDK.Participant) {
        DispatchQueue.main.async {
            self.participantCountLabel.setTitle("\(liveEvent.participantCount)", for: .normal)
        }
    }
    
    func didParticipantExit(_ liveEvent: SendbirdLiveSDK.LiveEvent, participant: SendbirdLiveSDK.Participant) {
        DispatchQueue.main.async {
            self.participantCountLabel.setTitle("\(liveEvent.participantCount)", for: .normal)
        }
    }
    
    func didHostMuteAudioInput(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostMuteAudioInput")
    }
    
    func didHostUnmuteAudioInput(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostUnmuteAudioInput")
    }
    
    func didHostStartVideo(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostStartVideo")
    }
    
    func didHostStopVideo(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        print("didHostStopVideo")
    }
    
    func didHostEnter(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        updateLiveEventInfo()
        print("didHostEnter")
    }
    
    func didHostExit(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        updateLiveEventInfo()
        print("didHostExit")
    }
    
    func didHostConnect(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        updateLiveEventInfo()
        print("didHostConnect")
    }
    
    func didHostDisconnect(_ liveEvent: SendbirdLiveSDK.LiveEvent, host: SendbirdLiveSDK.Host) {
        updateLiveEventInfo()
        print("didHostDisconnect")
    }
    
    func didLiveEventReady(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        updateLiveEventInfo()
        print("didLiveEventReady")
    }
    
    func didLiveEventStart(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        DispatchQueue.main.async {
            self.updateLiveEventInfo()
            print("didLiveEventStart")
        }
    }
    
    func didLiveEventEnd(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        print("didLiveEventEnd")
        guard liveEvent.endedBy != SendbirdLive.currentUser?.userId else { return }
        self.updateLiveEventInfo()
        LiveStreamManager.shared.exitLiveEvent(liveEvent)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view.makeToast("Live Event has ended",
                           position: .bottom,
                           completion: { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func didLiveEventInfoUpdate(_ liveEvent: SendbirdLiveSDK.LiveEvent) {
        updateLiveEventInfo()
        print("didLiveEventInfoUpdate")
    }
    
    func didExit(_ liveEvent: SendbirdLiveSDK.LiveEvent, error: Error) {
        print("didExit")
        DispatchQueue.main.async {  [weak self] in
            guard let self else { return }
            self.view.makeToast("You have been disconnected from the Live Event",
                           position: .bottom,
                           completion: { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            })
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

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage()}
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    func resize(with targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let scale = max(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: size.width * scale,
            height: size.height * scale
        )
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        
        return scaledImage
    }
}

extension LiveEvent {
    func getRandomCoverColor() -> UIColor {
        let seed = liveEventId.hash
        srand48(seed)
        let random = UInt64(5 * drand48())
        switch random {
        case 0: return UIColor(red: 89/255, green: 89/255, blue: 211/255, alpha: 1.0)
        case 1: return UIColor(red: 2/255, green: 125/255, blue: 105/255, alpha: 1.0)
        case 2: return UIColor(red: 132/255, green: 75/255, blue: 8/255, alpha: 1.0)
        case 3: return UIColor(red: 75/255, green: 17/255, blue: 161/255, alpha: 1.0)
        default: return UIColor(red: 128/255, green: 18/255, blue: 179/255, alpha: 1.0)
        }
    }
}
