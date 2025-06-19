//
//  UploadProductViewController.swift
//  YCT
//
//  Created by Lucky on 28/03/2024.
//

import Foundation
import UIKit
import Alamofire
import ZLPhotoBrowser

final class UploadProductViewController: YCTBaseViewController {
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "login.close"), for: .normal)
        button.add(.touchUpInside) { [unowned self] _ in
            self.dismiss(animated: true)
        }
        return button
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var liveCategoryTextField: UITextField!
    @IBOutlet weak var selectCategoryButton: UIButton! {
        didSet {
            selectCategoryButton.add(.touchUpInside) { [unowned self] _ in
                self.didSelectCategory()
            }
        }
    }
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.add(.touchUpInside) { [unowned self] _ in
                submitProduct()
            }
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(didSelectImage))
            imageView.addGestureRecognizer(tapGesture)
        }
    }
    private let screenType: ScreenType
    private var liveCategories: [String] {
        return LiveStream.liveCategories
    }
    private var selectedLiveCategory: Int = 0
    private var selectImage: (hasSelectNewImage: Bool, image: UIImage?) = (false, nil)
    
    // MARK: - Constructors
    init(screenType: ScreenType = .create) {
        self.screenType = screenType
        super.init(nibName: "UploadProductViewController", bundle: Bundle.main)
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
        
        renderProductIfEdit()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        self.view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaGuide).inset(16)
            make.size.equalTo(40)
        }
    }
    
    private func renderProductIfEdit() {
        if case .update(let product, _) = screenType {
            self.titleLabel.text = "Manage Product"
            self.nameTextField.text = product.productName
            if let price = product.price {
                self.priceTextField.text = "\(price)"
            }
            if let categoryName = product.categoryName {
                if let index = liveCategories.enumerated().first(where: { $1 == categoryName })?.0 {
                    selectedLiveCategory = index
                    liveCategoryTextField.text = liveCategories.get(index)
                }
            }
            self.introductionTextView.text = product.introduction
            if let imageUrl = product.media.first?.mediaUrl {
                self.imageView.sd_setImage(with: URL(string: imageUrl)) { [weak self] image, _, _, _ in
                    self?.selectImage = (false, image)
                }
            }
        }
    }
    
    private func didSelectCategory() {
        let alert = UIAlertController(style: .actionSheet, title: "Select Live Category", message: "")

        let pickerViewValues: [[String]] = [self.liveCategories]
        let pickerViewSelectedValues: [PickerViewViewController.Index] = [(column: 0, row: self.selectedLiveCategory)]

        alert.addPickerView(values: pickerViewValues, initialSelections: pickerViewSelectedValues) { [weak self] vc, picker, index, values in
            guard let self = self else { return }
            self.selectedLiveCategory = index.row
            self.liveCategoryTextField.text = self.liveCategories.get(index.row)
        }
        alert.addAction(title: "Done", style: .cancel)
        self.present(alert, animated: true)
    }
    
    @objc private func didSelectImage() {
        ZLPhotoConfiguration.default()
            .maxSelectCount(1)
            .allowSelectVideo(false)
            .allowSelectLivePhoto(false)
            .allowEditImage(true)
            .allowEditVideo(false)
            .allowSelectGif(false)
            .allowSelectOriginal(false)

        /// Using this init method, you can continue editing the selected photo
        let ac = ZLPhotoPreviewSheet()

        ac.selectImageBlock = { [weak self] results, isOriginal in
            guard let self else { return }
            let image = results.filter {$0.asset.mediaType == .image}.map { $0.image }.first
            self.imageView.image = image
            self.selectImage = (true, image)
        }

        ac.showPhotoLibrary(sender: self)
        
    }
    
    private func submitProduct() {
        let productName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let priceStr = priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let price = Double(priceStr) ?? 0
        let introduction = introductionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let categoryName = liveCategories.get(selectedLiveCategory) ?? ""
        
        guard productName.isNotEmpty else {
            view.showToast("Please input the name", position: .bottom)
            return
        }
        
        guard price > 0 else {
            view.showToast("Please input the price", position: .bottom)
            return
        }
        guard let image = selectImage.image else {
            view.showToast("Please upload the image", position: .bottom)
            return
        }
        
        if selectImage.hasSelectNewImage {
            // Has select new image -> User create/edit product
            uploadImage(image: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let imageUrl):
                    self.createOrUpdateProduct(productName: productName,
                                          categoryName: categoryName,
                                          price: price,
                                          introduction: introduction,
                                          medias: [.init(mediaType: "image",
                                                         mediaUrl: imageUrl)])
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                }
            }
        } else {
            // Has not select any image -> User edit product and doesn't want to update media
            createOrUpdateProduct(productName: productName,
                                  categoryName: categoryName,
                                  price: price,
                                  introduction: introduction,
                                  medias: nil)
        }
    }
    
    private func createOrUpdateProduct(productName: String,
                                       categoryName: String,
                                       price: Double,
                                       introduction: String,
                                       medias: [MediaRes]?) {
        switch screenType {
        case .create:
            let product = Product(productId: nil,
                                  categoryName: categoryName,
                                  categoryId: nil,
                                  productName: productName,
                                  price: price,
                                  introduction: introduction,
                                  media: medias ?? [])
            YCTApiCreateProduct(product: product).startWithCompletionBlock(success: { [weak self] baseRequest in
                self?.dismiss(animated: true)
            }, failure: { [weak self] baseRequest in
                guard let self else { return }
                if let error = baseRequest.error {
                    self.view.makeToast(error.localizedDescription)
                }
            })
        case .update(let product, let successCompletion):
            if let productId = product.productId {
                let newProduct = Product(productId: productId,
                                         categoryName: categoryName,
                                         categoryId: nil,
                                         productName: productName,
                                         price: price,
                                         introduction: introduction,
                                         media: medias ?? product.media)
                YCTApiUpdateProduct(productId: productId,
                                    product: newProduct).startWithCompletionBlock(success: { [weak self] baseRequest in
                    guard let self else { return }

                    if let data = baseRequest.responseData,
                       let response = try? JSONDecoder().decode(ResponseModel<Bool>.self, from: data),
                       response.data {
                        successCompletion?(newProduct)
                    }
                    self.dismiss(animated: true)
                }, failure: { [weak self] baseRequest in
                    guard let self else { return }

                    if let error = baseRequest.error {
                        self.view.makeToast(error.localizedDescription)
                    }
                })
            }
        }
    }
    
    private func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
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

extension UploadProductViewController {
    enum ScreenType {
        case create
        case update(product: Product, successCompletion: ((Product) -> Void)?)
    }
}
