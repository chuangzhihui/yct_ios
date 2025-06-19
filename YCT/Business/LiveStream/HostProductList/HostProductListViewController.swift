//
//  HostProductListViewController.swift
//  YCT
//
//  Created by Lucky on 28/03/2024.
//

import Foundation
import UIKit
import Alamofire

final class HostProductListViewController: YCTBaseViewController {
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "login.close"), for: .normal)
        button.add(.touchUpInside) { [unowned self] _ in
            self.dismiss(animated: true)
        }
        return button
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellClass: ProductCell.self)
        tableView.dataSource = self
        tableView.rowHeight = 100
        return tableView
    }()
    private var products: [Product] = []
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
        
        getProductList()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        self.view.addSubview(closeButton)
        self.view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaGuide).inset(16)
            make.size.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(safeAreaGuide)
        }
    }
    
    private func getProductList() {
        let userIdStr = YCTUserDataManager.sharedInstance().loginModel.userIdFromIMName
        guard let userId = Int(userIdStr) else { return }
        YCTApiFetchProduct(userId: userId).startWithCompletionBlock(success: { [unowned self] baseRequest in
            if let data = baseRequest.responseData {
                if let response = try? JSONDecoder().decode(ResponseModel<[Product]>.self, from: data) {
                    self.products = response.data
                    self.tableView.reloadData()
                }
            }
        }, failure: { [unowned self] baseRequest in
            if let error = baseRequest.error {
                DispatchQueue.main.async { [unowned self] in
                    self.view.makeToast(error.localizedDescription)
                }
            }
        })

    }
}

extension HostProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: ProductCell.self, forIndexPath: indexPath)
        if let product = products.get(indexPath.row) {
            cell.bind(imageUrl: product.media.first?.mediaUrl,
                      title: product.productName ?? "",
                      subtitle: product.introduction ?? "",
                      price: nil,
                      cellType: .host)
            cell.didTapManage = { [unowned self] in
                let vc = UploadProductViewController(screenType:
                        .update(product: product,
                                successCompletion: { [unowned self] newProduct in
                    self.products[indexPath.row] = newProduct
                    self.tableView.reloadData()
                }))
                self.present(vc, animated: true)
            }
        } else {
            cell.bind(imageUrl: nil,
                      title: "",
                      subtitle: "",
                      price: nil,
                      cellType: .host)
        }
        return cell
    }
    
    
}
