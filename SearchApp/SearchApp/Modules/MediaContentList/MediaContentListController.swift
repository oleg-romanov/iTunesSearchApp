//
//  ViewController.swift
//  SearchApp
//
//  Created by Олег Романов on 05.04.2024.
//

import UIKit

final class MediaContentListController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let searchBarPlaceholder = "Search in SearchApp"
        static let collectionViewCellIdentifier = "ContentCell"
        static let tableViewCellIdentifier = "SearchHistoryCell"
        static let maintitleInfoStartedStateText = "Use the search to find content on iTunes"
        static let maintitleInfoEmptyResultStateText = "Nothing was found"
        static let collectionLastItemBias = 5
        
        static let collectionViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let collectionViewMinimumInteritemSpacing: CGFloat = 10
        static let collectionViewMinimumLineSpacing: CGFloat = 10
        static let collectionViewCellWidth: CGFloat = (UIScreen.main.bounds.width - (Constants.collectionViewInsets.left + Constants.collectionViewInsets.right + Constants.collectionViewMinimumInteritemSpacing)) / 2
        static let collectionViewCellHeight: CGFloat = Constants.collectionViewCellWidth + 100
        
        static let mainTitleInfoLeadingInset: CGFloat = 16
        static let mainTitleInfoTrailingInset: CGFloat = -16
        
        static let viewBackgroundColor: UIColor = .systemBackground
    }
    
    // MARK: Instance Properties
    
    private var interactor: MediaContentListBusinessLogic!
    private var router: MediaContentListRoutingLogic!
    
    private var mediaContentList = [MediaContentListViewModel]()
    
    private var searchHistoryList = [SearchQuery]()
    
    private var allHistory = [SearchQuery]()
    
    private var lastFivesearchRequests = [SearchQuery]()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.collectionViewMinimumInteritemSpacing
        layout.minimumLineSpacing = Constants.collectionViewMinimumLineSpacing
        layout.sectionInset = Constants.collectionViewInsets
        
        layout.itemSize = CGSize(width: Constants.collectionViewCellWidth, height: Constants.collectionViewCellHeight)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: Constants.collectionViewCellIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = false
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchHistoryCell.self, forCellReuseIdentifier: Constants.tableViewCellIdentifier)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var mainTitleInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = Constants.maintitleInfoStartedStateText
        label.sizeToFit()
        return label
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await interactor.fetchAllHistoryRequests()
        }
    }
    
    // MARK: Setup
    
    func setupComponents(
        interactor: MediaContentListBusinessLogic,
        router: MediaContentListRoutingLogic
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    private func setup() {
        view.backgroundColor = Constants.viewBackgroundColor
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(mainTitleInfo)
        view.addSubview(tableView)
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainTitleInfo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainTitleInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitleInfo.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Constants.mainTitleInfoLeadingInset),
            mainTitleInfo.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: Constants.mainTitleInfoTrailingInset)
        ])
    }
    
    private func changeVisibilityTableAndCollectionView() {
        collectionView.isHidden.toggle()
        tableView.isHidden.toggle()
        mainTitleInfo.isHidden.toggle()
    }
}

// MARK: - UICollectionViewDataSource

extension MediaContentListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaContentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellIdentifier, for: indexPath) as? ContentCell
        cell?.configure(with: mediaContentList[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension MediaContentListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.routeToDetailMediaContent(with: mediaContentList[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = self.collectionView.numberOfItems(inSection: indexPath.section) - 1
        if lastRowIndex > .zero, self.collectionView.contentOffset.y > self.collectionView.bounds.height {
            if indexPath.row > lastRowIndex - Constants.collectionLastItemBias {
                // TODO: request for more results with offset
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MediaContentListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier, for: indexPath) as? SearchHistoryCell
        cell?.configure(with: searchHistoryList[indexPath.row].text)
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension MediaContentListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SearchHistoryCell
        searchController.searchBar.text = cell?.titleLabel.text
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - MediaContentListDisplayLogic

extension MediaContentListController: MediaContentListDisplayLogic {
    func displaySearchHistory(_ searchHistory: [SearchQuery], fiveLastRequests: [SearchQuery]) {
        lastFivesearchRequests = fiveLastRequests
        allHistory = searchHistory
        searchHistoryList = fiveLastRequests
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @MainActor func displayContentMediaList(mediaContentList: [MediaContentListViewModel]) {
        self.mediaContentList = mediaContentList
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainTitleInfo.isHidden = true
            if (mediaContentList.isEmpty) {
                mainTitleInfo.text = Constants.maintitleInfoEmptyResultStateText
                self.mainTitleInfo.isHidden = false
            }
            self.hideListLoading()
            self.collectionView.reloadData()
        }
    }
    
    @MainActor func displayError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.hideListLoading()
            // TODO: Показ алерта
            print(message)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension MediaContentListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchTerm.isEmpty {
            searchHistoryList = lastFivesearchRequests
            tableView.reloadData()
            return
        }
        
        let filtered = allHistory.filter { $0.text.contains(searchTerm) }
        
        if !filtered.isEmpty {
            searchHistoryList = filtered
            tableView.reloadData()
        } else {
            searchHistoryList = []
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate

extension MediaContentListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showListLoading()
        if let searchText = searchBar.text {
            interactor.saveSearchRequest(searchText.lowercased(), timestamp: Date.now)
            Task {
                await interactor.fetchContentMediaList(term: searchText)
                await interactor.fetchAllHistoryRequests()
            }
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        changeVisibilityTableAndCollectionView()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        changeVisibilityTableAndCollectionView()
        searchHistoryList = lastFivesearchRequests
        tableView.reloadData()
    }
}
