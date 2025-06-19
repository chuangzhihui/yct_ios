//
//  SearchLiveViewController.swift
//  YCT
//
//  Created by Lucky on 23/03/2024.
//

import Foundation
import UIKit
import SendbirdLiveSDK

final class SearchLiveViewController: YCTBaseViewController {
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(cellClass: SearchLiveCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    private lazy var seachBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search live broadcast room"
        searchBar.delegate = self
        return searchBar
    }()
    
    private var origLiveEvents: [LiveEvent] = []
    private var liveEvents: [LiveEvent] = []

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
        getLiveEventList()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        navigationItem.titleView = seachBarView

        self.view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getLiveEventList() {
        let now = Int64(Date().timeIntervalSince1970 * 1000)

        LiveStreamManager.shared.getLiveEventList(createdDateLastLive: now,
                                                  limit: 100) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let liveEvents):
                self.origLiveEvents = liveEvents
                self.liveEvents = liveEvents
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(_):
                break
            }
        }
    }
    
    @objc private func didPullToRefresh() {
        seachBarView.textField?.text = ""
        getLiveEventList()
    }
}

extension SearchLiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellClass: SearchLiveCell.self, forIndexPath: indexPath)
        let liveEvent = liveEvents.get(indexPath.row)
        cell.bind(name: liveEvent?.title,
                  category: liveEvent?.customItems["category"],
                  imageUrl: liveEvent?.coverURL,
                  liveStatus: liveEvent?.state)
        return cell
    }
}

extension SearchLiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 5
        let width = (collectionView.frame.size.width - CGFloat(padding) * 2) / CGFloat(2)
        let height = width / 9 * 16
        return CGSize(width: width, height: height)
    }
}

extension SearchLiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let liveEvent = liveEvents.get(indexPath.row),
           (liveEvent.state == .ongoing || liveEvent.state == .ready) {
            DispatchQueue.main.async { [weak self] in
                let vc = LiveRoomParticipantViewController.initWithStoryboard()
                vc.modalPresentationStyle = .fullScreen
                vc.liveEvent = liveEvent
                self?.present(vc, animated: true)
            }
        }
    }
}

extension SearchLiveViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText.isEmpty {
            liveEvents = origLiveEvents
            collectionView.reloadData()
        } else {
            liveEvents = origLiveEvents.filter({ liveEvent in
                return liveEvent.title?.range(of: searchText) != nil
            })
            collectionView.reloadData()
        }
    }
}
