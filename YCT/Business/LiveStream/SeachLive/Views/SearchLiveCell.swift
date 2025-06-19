//
//  SearchLiveCell.swift
//  YCT
//
//  Created by Lucky on 23/03/2024.
//

import Foundation
import SendbirdLiveSDK

final class SearchLiveCell: UICollectionViewCell {
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
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
        nameLabel.font = .systemFont(ofSize: 12)
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
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Click to Enter", for: .normal)
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
    }()
    // MARK: - Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.sd_cancelCurrentImageLoad()
        thumbnailImageView.sd_setImage(with: nil)
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        self.clipsToBounds = true
        self.backgroundColor = .black
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
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        categoryWrapperView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }
        nameWrapperView.snp.makeConstraints { make in
            make.bottom.equalTo(categoryWrapperView.snp.top).offset(-8)
            make.leading.equalToSuperview().inset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }
        liveStatusWrapperView.snp.makeConstraints { make in
            make.bottom.equalTo(nameWrapperView.snp.top).offset(-8)
            make.leading.equalToSuperview().inset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
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
    func bind(name: String?, 
              category: String?,
              imageUrl: String?,
              liveStatus: LiveEvent.State?) {
        if let imageUrl {
            thumbnailImageView.sd_setImage(with: URL(string: imageUrl))
        } else {
            thumbnailImageView.sd_setImage(with: nil)
        }
        nameLabel.text = name
        categoryLabel.text = category
        if liveStatus == .ongoing {
            liveStatusLabel.text = "LIVE"
            liveStatusWrapperView.backgroundColor = .red
            enterButton.isHidden = false
        } else {
            liveStatusLabel.text = liveStatus?.rawValue.capitalized
            liveStatusWrapperView.backgroundColor = .gray
            enterButton.isHidden = true
        }
    }
}
