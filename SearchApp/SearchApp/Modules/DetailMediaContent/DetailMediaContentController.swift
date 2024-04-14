//
//  DetailMediaContentController.swift
//  SearchApp
//
//  Created by Олег Романов on 09.04.2024.
//

import UIKit

final class DetailMediaContentController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let trackNameLabelNumberOfLines: Int = 3
        static let trackNameLabelTextAlignment: NSTextAlignment = .center
        static let trackNameLabelFont: UIFont = .systemFont(ofSize: 20, weight: .medium)

        static let artistNameAndKindAndHyperLinkStackViewAxis: NSLayoutConstraint.Axis = .vertical
        static let artistNameAndKindAndHyperLinkStackViewAlignment: UIStackView.Alignment = .leading
        static let artistNameAndKindAndHyperLinkStackViewSpacing: CGFloat = 8

        static let infoStackViewAxis: NSLayoutConstraint.Axis = .vertical
        static let infoStackViewAlignment: UIStackView.Alignment = .fill
        static let infoStackViewSpacing: CGFloat = 8

        static let posterImageAndInfoStackViewAxis: NSLayoutConstraint.Axis = .horizontal
        static let posterImageAndInfoStackViewAlignment: UIStackView.Alignment = .leading
        static let posterImageAndInfoStackViewSpacing: CGFloat = 16

        static let artistNameLabelFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
        static let hyperLinkLabelFont: UIFont = .systemFont(ofSize: 18, weight: .medium)
        static let artistNameLabelTextColor: UIColor = .gray

        static let kindLabelTextColor: UIColor = .lightGray

        static let hyperLinkLabelText: String = "Learn more..."
        static let hyperLinkTextColor: UIColor = .systemBlue
        
        static let descriptionTitleLabelText: String = "Description:"

        static let viewBackgroundColor: UIColor = .systemBackground

        static let separatorViewColor: UIColor = .systemGray5
        static let separatorViewHeight: CGFloat = 2

        static let titleLabelFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
        static let titleLabelTextColor: UIColor = .gray

        static let posterImageViewHeight: CGFloat = 150
        static let posterImageViewWidth: CGFloat = 100
        
        static let posterImageAndInfoStackViewTopConstant: CGFloat = 16
        static let posterImageAndInfoStackViewLeadingConstant: CGFloat = 16
        static let posterImageAndInfoStackViewTrailingConstant: CGFloat = -16
        
        static let separatorViewTopConstant: CGFloat = 32
        static let separatorViewLeadingConstant: CGFloat = 8
        static let separatorViewTrailingConstant: CGFloat = -8
        
        static let descriptionTitleLabelTopConstant: CGFloat = 16
        static let descriptionTitleLabelLeadingConstant: CGFloat = 16
        
        static let descriptionTextLabelTopConstant: CGFloat = 8
        static let descriptionTextLabelLeadingConstant: CGFloat = 16
        static let descriptionTextLabelTrailingConstant: CGFloat = -16
        static let descriptionTextLabelFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
        
        static let aboutArtistTitleLabelTopConstant: CGFloat = 16
        static let aboutArtistTitleLabelText: String = "Artist:"
        
        static let artistInfoStackViewTopConstant: CGFloat = 8
        static let artistInfoStackViewLeadingConstant: CGFloat = 16
        static let artistInfoStackViewTrailingConstant: CGFloat = -16
        static let artistInfoStackViewBottomConstant: CGFloat = -16
        static let artistInfoStackViewSpacing: CGFloat = 8
    }
    
    // MARK: Instance Properties
    
    private var interactor: DetailMediaContentBusinessLogic!
    private var router: DetailMediaContentRoutingLogic!
    
    private var artistId: Int?
    private var aboutTrackHyperLinkUrl: URL?
    private var aboutAnArtistHyperLinkUrl: URL?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var posterImageView: URLImageView = {
        let imageView = URLImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constants.trackNameLabelNumberOfLines
        label.font = Constants.artistNameLabelFont
        label.textColor = Constants.artistNameLabelTextColor
        return label
    }()
    
    private lazy var kindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.kindLabelTextColor
        label.font = Constants.artistNameLabelFont
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutTrackHyperLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.hyperLinkLabelFont
        label.text = Constants.hyperLinkLabelText
        label.textColor = Constants.hyperLinkTextColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hyperLinkLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var aboutAnArtistHyperLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.hyperLinkLabelFont
        label.text = Constants.hyperLinkLabelText
        label.textColor = Constants.hyperLinkTextColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hyperLinkLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.separatorViewColor
        return view
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.descriptionTitleLabelText
        label.font = Constants.titleLabelFont
        label.textColor = Constants.titleLabelTextColor
        return label
    }()
    
    private lazy var descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.descriptionTextLabelFont
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var artistNameAndKindStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistNameLabel, kindLabel, releaseDateLabel])
        stackView.axis = Constants.artistNameAndKindAndHyperLinkStackViewAxis
        stackView.alignment = Constants.artistNameAndKindAndHyperLinkStackViewAlignment
        stackView.spacing = Constants.artistNameAndKindAndHyperLinkStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistNameAndKindStackView, aboutTrackHyperLinkLabel])
        stackView.axis = Constants.infoStackViewAxis
        stackView.alignment = Constants.infoStackViewAlignment
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.infoStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var posterImageAndInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView, infoStackView])
        stackView.axis = Constants.posterImageAndInfoStackViewAxis
        stackView.alignment = Constants.posterImageAndInfoStackViewAlignment
        stackView.spacing = Constants.posterImageAndInfoStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let aboutArtistTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.aboutArtistTitleLabelText
        label.font = Constants.titleLabelFont
        label.textColor = Constants.titleLabelTextColor
        return label
    }()
    
    private lazy var nameAndTypeArtistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.descriptionTextLabelFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var primaryArtistGenreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.descriptionTextLabelFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var artistInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameAndTypeArtistLabel, primaryArtistGenreLabel, aboutAnArtistHyperLinkLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.artistInfoStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        showListLoading()
        guard 
            let id = artistId
        else {
            hideListLoading()
            return
        }
        Task {
            await interactor.fetchArtistInfo(by: id)
        }
    }
    
    // MARK: Setup
    
    func setupComponents(
        interactor: DetailMediaContentBusinessLogic,
        router: DetailMediaContentRoutingLogic
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    private func setup() {
        view.backgroundColor = Constants.viewBackgroundColor
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(posterImageAndInfoStackView)
        scrollView.addSubview(separatorView)
        scrollView.addSubview(descriptionTextLabel)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(aboutArtistTitleLabel)
        scrollView.addSubview(artistInfoStackView)
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            posterImageView.heightAnchor.constraint(equalToConstant: Constants.posterImageViewHeight),
            posterImageView.widthAnchor.constraint(equalToConstant: Constants.posterImageViewWidth),

            posterImageAndInfoStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.posterImageAndInfoStackViewTopConstant),
            posterImageAndInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.posterImageAndInfoStackViewLeadingConstant),
            posterImageAndInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.posterImageAndInfoStackViewTrailingConstant),

            infoStackView.heightAnchor.constraint(equalTo: posterImageView.heightAnchor),

            separatorView.topAnchor.constraint(equalTo: posterImageAndInfoStackView.bottomAnchor, constant: Constants.separatorViewTopConstant),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.separatorViewLeadingConstant),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.separatorViewTrailingConstant),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorViewHeight),

            descriptionTitleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.descriptionTitleLabelTopConstant),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.descriptionTitleLabelLeadingConstant),

            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: Constants.descriptionTextLabelTopConstant),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.descriptionTextLabelLeadingConstant),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.descriptionTextLabelTrailingConstant),

            aboutArtistTitleLabel.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: Constants.aboutArtistTitleLabelTopConstant),
            aboutArtistTitleLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),

            artistInfoStackView.topAnchor.constraint(equalTo: aboutArtistTitleLabel.bottomAnchor, constant: Constants.artistInfoStackViewTopConstant),
            artistInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.artistInfoStackViewLeadingConstant),
            artistInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.artistInfoStackViewTrailingConstant),
            artistInfoStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.artistInfoStackViewBottomConstant)
        ])
    }
    
    // MARK: Actions
    
    @objc private func hyperLinkLabelTapped(_ recognizer: UITapGestureRecognizer) {
        
        guard let hyperLinkUrl = (recognizer.view === aboutTrackHyperLinkLabel ?  aboutTrackHyperLinkUrl : aboutAnArtistHyperLinkUrl) else { return }
        
        if UIApplication.shared.canOpenURL(hyperLinkUrl) {
            UIApplication.shared.open(hyperLinkUrl)
        }
    }
}

// MARK: - DetailMediaContentDisplayLogic

extension DetailMediaContentController : DetailMediaContentDisplayLogic {
    
    func configure(by model: MediaContentListViewModel) {
        guard let url = URL(string: model.artWorkUrl) else { return }
        artistId = model.artistId
        posterImageView.loadImage(from: url)
        navigationItem.title = model.trackName
        artistNameLabel.text = model.artistName
        kindLabel.text = model.kind
        releaseDateLabel.text = model.releaseDate
        aboutTrackHyperLinkUrl = URL(string: model.trackViewUrlString)
        descriptionTextLabel.text = !model.description.isEmpty ? model.description : "There is no description for this content."
    }
    
    @MainActor func displayArtistInfo(artistInfo: ArtistInfoViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.hideListLoading()
            self?.aboutAnArtistHyperLinkUrl = URL(string: artistInfo.artistLinkUrl)
            self?.nameAndTypeArtistLabel.text = "\(artistInfo.artistName) - \(artistInfo.artistType)"
            self?.primaryArtistGenreLabel.text = "Primary genre - \(artistInfo.primaryGenreName)"
        }
    }
    
    func displayError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.hideListLoading()
            self?.showErrorAlert(message: message)
        }
    }
}
