//
//  LiveEventListViewController.swift
//  YCT
//
//  Created by Tan Vo on 03/01/2024.
//

import UIKit
import SDWebImage
import SendbirdLiveSDK
import JXCategoryView
import SnapKit

class LiveEventListViewController: YCTBaseViewController {
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.isPagingEnabled = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(cellClass: LiveEventCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.alwaysBounceVertical = true
        return tableView
    }()
    
    private lazy var searchButton: UIImageView = {
        let button = UIImageView()
        button.isUserInteractionEnabled = true
        button.image = UIImage(named: "search_magnifier")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearch))
        button.addGestureRecognizer(tapGesture)
        return button
    }()

    private var liveEvents: [LiveEvent] = []
    private var currentIndexPath: IndexPath?
    private var firstTimeLoad = true
    private var isLoadingNextPage = false
    private var isReachEnd = false

    // MARK: - View life cycle
    override func loadView() {
        super.loadView()

        setupViews()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didLoginSendbird),
                                               name: LiveStreamManager.didLoginNotificationName,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLiveEventList(isReload: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentIndexPath {
            (tableView.cellForRow(at: currentIndexPath) as? LiveEventCell)?.stopLiveEvent()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func naviagtionBarHidden() -> Bool {
        return true
    }
    // MARK: - Private methods
    private func setupViews() {
        self.view.addSubview(tableView)
        self.view.addSubview(searchButton)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(30)
        }
    }
    
    private func getLiveEventList(isReload: Bool) {
        if isReload {
            isReachEnd = false
        } else {
            if isLoadingNextPage || isReachEnd {
                return
            }
        }
        isLoadingNextPage = true
        
        let now = Int64(Date().timeIntervalSince1970 * 1000)
        let createdDateLastLive = isReload ? now : (liveEvents.last?.createdAt ?? now)
        LiveStreamManager.shared.getLiveEventList(createdDateLastLive: createdDateLastLive) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let liveEvents):
                if isReload {
                    self.liveEvents = liveEvents
                    self.firstTimeLoad = true
                    if !liveEvents.isEmpty {
                        self.currentIndexPath = .init(row: 0, section: 0)
                    }
                } else {
                    if liveEvents.isEmpty {
                        self.isReachEnd = true
                    } else {
                        self.liveEvents.append(liveEvents)
                    }
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }

                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(_):
                break
            }
            self.isLoadingNextPage = false
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        LiveStreamManager.shared.logout { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
    }
    
    @objc private func didPullToRefresh() {
        getLiveEventList(isReload: true)
    }
    
    @objc private func didTapSearch() {
        let vc = SearchLiveViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didLoginSendbird() {
        getLiveEventList(isReload: true)
    }
}

extension LiveEventListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: LiveEventCell.self, forIndexPath: indexPath)
        if let liveEvent = liveEvents.get(indexPath.row) {
            cell.bind(liveEvent: liveEvent)
            if firstTimeLoad, indexPath.row == 0 {
                firstTimeLoad = false
                cell.startLiveEvent(liveEvent: liveEvent, indexPath: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let reachingIndex = liveEvents.count - 3
        if reachingIndex > 0, indexPath.row >= liveEvents.count - 3 {
            getLiveEventList(isReload: false)
        }
    }
}

extension LiveEventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let liveEvent = liveEvents.get(indexPath.row) {
            if let currentIndexPath {
                (tableView.cellForRow(at: currentIndexPath) as? LiveEventCell)?.stopLiveEvent(completion: {
                    DispatchQueue.main.async { [weak self] in
                        let vc = LiveRoomParticipantViewController.initWithStoryboard()
                        vc.modalPresentationStyle = .fullScreen
                        vc.liveEvent = liveEvent
                        self?.present(vc, animated: true)
                    }
                })
            }
            
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}

extension LiveEventListViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let tv = scrollView as? UITableView {
            if let path = tv.indexPathForRow(at: targetContentOffset.pointee) {
                if self.currentIndexPath != path {
                    if let currentIndexPath {
                        (tableView.cellForRow(at: currentIndexPath) as? LiveEventCell)?.stopLiveEvent()
                    }
                    if let liveEvent = liveEvents.get(path.row) {
                        (tableView.cellForRow(at: path) as? LiveEventCell)?.startLiveEvent(liveEvent: liveEvent, indexPath: path)
                    }
                    self.currentIndexPath = path
                }
            }
        }
    }
}

extension Int {
    func dateString() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm, dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
