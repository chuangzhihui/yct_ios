//
//  ParticipantProductListViewController.swift
//  YCT
//
//  Created by Lucky on 25/03/2024.
//

import Foundation
import UIKit
import Alamofire
import FloatingPanel

final class ParticipantProductListViewController: YCTBaseViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellClass: ProductCell.self)
        tableView.dataSource = self
        tableView.rowHeight = 100
        return tableView
    }()
    private var products: [Product] = []
    private let hostId: Int
    // MARK: - Constructors
    init(hostId: Int) {
        self.hostId = hostId
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
        self.view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getProductList() {
        YCTApiFetchProduct(userId: hostId).startWithCompletionBlock(success: { [unowned self] baseRequest in
            if let data = baseRequest.responseData {
                if let response = try? JSONDecoder().decode(ResponseModel<[Product]>.self, from: data) {
                    self.products = response.data
                    self.tableView.reloadData()
                }
            }
        }, failure: { [unowned self] baseRequest in
            if let error = baseRequest.error {
                self.view.makeToast(error.localizedDescription)
            }
        })

    }
}

extension ParticipantProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: ProductCell.self, forIndexPath: indexPath)
        if let product = products.get(indexPath.row) {
            cell.bind(imageUrl: product.media.first?.mediaUrl,
                      title: product.productName ?? "",
                      subtitle: product.introduction ?? "",
                      price: product.price,
                      cellType: .participant)
            cell.didTapMore = { [unowned self] in
                let fpc = FloatingPanelController()
                let contentVC = ParticipantProductDetailViewController(product: product)
                fpc.set(contentViewController: contentVC)
                fpc.layout = FixedHeightPanelLayout(height: 350)
                fpc.isRemovalInteractionEnabled = true
                fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
                self.present(fpc, animated: true)
            }
        } else {
            cell.bind(imageUrl: nil,
                      title: "",
                      subtitle: "",
                      price: nil,
                      cellType: .participant)
        }
        return cell
    }
    
    
}
