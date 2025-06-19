//
//  LiveEventCell.swift
//  YCT
//
//  Created by Lucky on 21/03/2024.
//

import Foundation
import UIKit
import SendbirdLiveSDK
import SDWebImage

class LiveEventCell: UITableViewCell {
    
    private lazy var liveStatusWrapperView = UIView()
    private lazy var liveStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private lazy var nameWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        return nameLabel
    }()
    private lazy var categoryWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Click to Enter", for: .normal)
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var videoView = UIView()
    private lazy var sendbirdVideoView: SendbirdVideoView = {
        let sendbirdVideoView = SendbirdVideoView(frame: .zero,
                                                  contentMode: .scaleAspectFill)
        sendbirdVideoView.backgroundColor = UIColor(white: 44.0 / 255.0, alpha: 1.0)
        return sendbirdVideoView
    }()
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private(set) var liveEvent: LiveEvent?
    private var currentIndexPath: IndexPath?
    // MARK: - Constructors
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.sd_cancelCurrentImageLoad()
        stopLiveEvent()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        selectionStyle = .none
        self.backgroundColor = .black
        self.contentView.addSubview(videoView)
        videoView.addSubview(sendbirdVideoView)
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(liveStatusWrapperView)
        self.contentView.addSubview(nameWrapperView)
        self.contentView.addSubview(categoryWrapperView)
        self.contentView.addSubview(enterButton)
        liveStatusWrapperView.addSubview(liveStatusLabel)
        nameWrapperView.addSubview(nameLabel)
        categoryWrapperView.addSubview(categoryLabel)
    }
    
    private func setupConstraints() {
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sendbirdVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalTo(videoView)
        }
        categoryWrapperView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(8)
        }
        nameWrapperView.snp.makeConstraints { make in
            make.bottom.equalTo(categoryWrapperView.snp.top).offset(-8)
            make.leading.equalToSuperview().inset(8)
        }
        liveStatusWrapperView.snp.makeConstraints { make in
            make.bottom.equalTo(nameWrapperView.snp.top).offset(-8)
            make.leading.equalToSuperview().inset(8)
        }
        categoryLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        nameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        liveStatusLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        enterButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Public methods
    func bind(liveEvent: LiveEvent) {
        nameLabel.text = liveEvent.title
        categoryLabel.text = liveEvent.customItems["category"]
        if let coverUrl = liveEvent.coverURL {
            thumbnailImageView.sd_setImage(with: .init(string: coverUrl))
        } else {
            thumbnailImageView.sd_setImage(with: nil)
        }
        if liveEvent.state == .ongoing {
            liveStatusLabel.text = "LIVE"
            liveStatusWrapperView.backgroundColor = .red
            enterButton.isHidden = false
        } else {
            liveStatusLabel.text = liveEvent.state.rawValue.capitalized
            liveStatusWrapperView.backgroundColor = .gray
            enterButton.isHidden = true
        }
    }
    
    func startLiveEvent(liveEvent: LiveEvent, indexPath: IndexPath) {
        self.liveEvent = liveEvent
        self.currentIndexPath = indexPath
        guard liveEvent.state == .ongoing else { return }
        LiveStreamManager.shared.enterLiveEvent(liveEvent, completion: { [weak self] _ in
            guard let self else { return }
            if indexPath == self.currentIndexPath {
                liveEvent.setVideoViewForLiveEvent(view: self.sendbirdVideoView, hostId: liveEvent.hosts.first?.hostId ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
                    guard let self else { return }
                    if indexPath == self.currentIndexPath {
                        self.thumbnailImageView.isHidden = true
                    }
                })
            } else {
                LiveStreamManager.shared.exitLiveEvent(liveEvent)
            }
        })
    }
    
    func stopLiveEvent(completion: (() -> Void)? = nil) {
        self.currentIndexPath = nil
        guard let liveEvent else {
            completion?()
            return
        }
        LiveStreamManager.shared.exitLiveEvent(liveEvent) { [weak self] _ in
            self?.liveEvent = nil
            completion?()
        }
        thumbnailImageView.isHidden = false
        sendbirdVideoView.removeFromSuperview()
        sendbirdVideoView.snp.removeConstraints()
        sendbirdVideoView = SendbirdVideoView(frame: .zero,
                                              contentMode: .scaleAspectFill)
        sendbirdVideoView.backgroundColor = UIColor(white: 44.0 / 255.0, alpha: 1.0)
        videoView.addSubview(sendbirdVideoView)
        sendbirdVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
