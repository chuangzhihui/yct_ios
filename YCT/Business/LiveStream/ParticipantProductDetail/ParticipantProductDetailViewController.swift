//
//  ParticipantProductDetailViewController.swift
//  YCT
//
//  Created by Lucky on 31/03/2024.
//

import Foundation

final class ParticipantProductDetailViewController: YCTBaseViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Product"
        label.numberOfLines = 2
        return label
    }()
    private lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "Introduction"
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "$0"
        return label
    }()
    private lazy var addCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD CART", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.add(.touchUpInside) { [unowned self] _ in
            
        }
        return button
    }()
    
    private var product: Product
    // MARK: - Constructors
    init(product: Product) {
        self.product = product
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
        renderData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        self.view.addSubviews(imageView, titleLabel, introductionLabel, priceLabel, addCartButton)
    }
    
    private func setupConstraints() {
        self.imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        self.introductionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        self.priceLabel.snp.makeConstraints { make in
            make.bottom.leading.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        self.addCartButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func renderData() {
        self.titleLabel.text = product.productName
        self.introductionLabel.text = product.introduction
        self.priceLabel.text = "$\(product.price ?? 0)"
        if let imageUrl = product.media.first?.mediaUrl {
            self.imageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
}

