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
        static let searchBarPlaceholder = "Поиск в SearchApp"
        static let navigationItemTitle = "Контент"
        static let cellIdentifier = "ContentCell"
        static let collectionLastItemBias = 5
        
        static let collectionViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let collectionViewMinimumInteritemSpacing: CGFloat = 10
        static let collectionViewMinimumLineSpacing: CGFloat = 10
        static let collectionViewCellWidth: CGFloat = (UIScreen.main.bounds.width - (Constants.collectionViewInsets.left + Constants.collectionViewInsets.right + Constants.collectionViewMinimumInteritemSpacing)) / 2
        static let collectionViewCellHeight: CGFloat = Constants.collectionViewCellWidth + 100
        
        static let viewBackgroundColor: UIColor = .systemBackground
    }
    
    // MARK: Instance Properties
    
    private var interactor: MediaContentListBusinessLogic!
    private var router: MediaContentListRoutingLogic!
    
    private var mediaContentList = [MediaContentListViewModel]()
    
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
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubviews()
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
        
        navigationItem.searchController = searchController
        navigationItem.title = Constants.navigationItemTitle
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource

extension MediaContentListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaContentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? ContentCell
        cell?.configure(with: mediaContentList[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

extension MediaContentListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = self.collectionView.numberOfItems(inSection: indexPath.section) - 1
        if lastRowIndex > .zero, self.collectionView.contentOffset.y > self.collectionView.bounds.height {
            if indexPath.row > lastRowIndex - Constants.collectionLastItemBias {
                // TODO: request for more results with offset
            }
        }
    }
}

// MARK: - MediaContentListDisplayLogic

extension MediaContentListController: MediaContentListDisplayLogic {
    @MainActor func displayContentMediaList(mediaContentList: [MediaContentListViewModel]) {
        self.mediaContentList = mediaContentList
        DispatchQueue.main.async { [weak self] in
            self?.hideListLoading()
            self?.collectionView.reloadData()
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
        // TODO: Обработка результатов поиска
        guard let searchTerm = searchController.searchBar.text else {
            return
        }
    }
}

// MARK: - UISearchBarDelegate

extension MediaContentListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showListLoading()
        if let searchText = searchBar.text {
            Task {
                await interactor.fetchContentMediaList(term: searchText)
            }
        }
        searchBar.resignFirstResponder()
    }
}
