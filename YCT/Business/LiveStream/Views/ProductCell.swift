//
//  ProductCell.swift
//  YCT
//
//  Created by Lucky on 25/03/2024.
//

import Foundation

final class ProductCell: UITableViewCell {
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    private lazy var titleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Product"
        label.numberOfLines = 2
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "Detail"
        return label
    }()
    private lazy var actionStackview: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [priceLabel, actionButton])
        sv.spacing = 8
        sv.axis = .vertical
        return sv
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "$0"
        label.textAlignment = .center
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("More", for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.add(.touchUpInside) { [unowned self] _ in
            switch cellType {
            case .participant:
                self.didTapMore?()
            case .host:
                self.didTapManage?()
            }
        }
        return button
    }()
    private var cellType: CellType = .participant
    var didTapMore: (() -> Void)?
    var didTapManage: (() -> Void)?
    
    // MARK: - Constructors
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.sd_cancelCurrentImageLoad()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(titleStackView)
        self.contentView.addSubview(actionStackview)
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(productImageView.snp.width)
        }
        titleStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.leading.equalTo(productImageView.snp.trailing).offset(16)
        }
        actionStackview.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.greaterThanOrEqualToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleStackView.snp.trailing).offset(16)
            make.width.equalTo(80)
        }
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    func bind(imageUrl: String?, title: String, subtitle: String, price: Double?, cellType: CellType) {
        self.cellType = cellType
        switch cellType {
        case .participant:
            actionButton.setTitle("More", for: .normal)
        case .host:
            actionButton.setTitle("Manage", for: .normal)
        }
        if let imageUrl {
            productImageView.sd_setImage(with: URL(string: imageUrl))
        } else {
            productImageView.sd_setImage(with: nil)
        }
        titleLabel.text = title
        subtitleLabel.text = subtitle
        if let price {
            priceLabel.text = "$\(price)"
            priceLabel.isHidden = false
        } else {
            priceLabel.isHidden = true
        }
    }
}

extension ProductCell {
    enum CellType {
        case participant
        case host
    }
}
