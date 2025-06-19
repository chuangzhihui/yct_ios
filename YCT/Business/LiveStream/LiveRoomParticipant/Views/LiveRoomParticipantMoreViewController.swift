//
//  LiveRoomParticipantMoreViewController.swift
//  YCT
//
//  Created by Lucky on 24/03/2024.
//

import Foundation
import UIKit

protocol LiveRoomParticipantMoreDelegate: AnyObject {
    func didTapFullscreen()
    func didTapShare()
    func didTapReport()
}
final class LiveRoomParticipantMoreViewController: YCTBaseViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var fullscreenContainer: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFullscreen))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private lazy var fullscreenLabel: UILabel = {
        let label = UILabel()
        label.text = "Full screen"
        return label
    }()
    private lazy var fullscreenImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "iconFullscreen")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .darkGray
        return imageView
    }()
    private lazy var shareContainer: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapShare))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.text = "Share"
        return label
    }()
    private lazy var shareImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "icon-share")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .darkGray
        return imageView
    }()
    private lazy var reportContainer: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapReport))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private lazy var reportLabel: UILabel = {
        let label = UILabel()
        label.text = "Report"
        return label
    }()
    private lazy var reportImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "icon-info")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    weak var delegate: LiveRoomParticipantMoreDelegate?
    // MARK: - Constructors
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func loadView() {
        super.loadView()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(fullscreenContainer)
        stackView.addArrangedSubview(shareContainer)
        stackView.addArrangedSubview(reportContainer)
        
        fullscreenContainer.addSubview(fullscreenImage)
        fullscreenContainer.addSubview(fullscreenLabel)

        shareContainer.addSubview(shareImage)
        shareContainer.addSubview(shareLabel)
        
        reportContainer.addSubview(reportImage)
        reportContainer.addSubview(reportLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fullscreenImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
        shareImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
        reportImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
        
        fullscreenLabel.snp.makeConstraints { make in
            make.top.equalTo(fullscreenImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        shareLabel.snp.makeConstraints { make in
            make.top.equalTo(shareImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        reportLabel.snp.makeConstraints { make in
            make.top.equalTo(reportImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func tapFullscreen() {
        delegate?.didTapFullscreen()
    }
    @objc private func tapShare() {
        delegate?.didTapShare()
    }
    @objc private func tapReport() {
        delegate?.didTapReport()
    }
}
