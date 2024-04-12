//
//  ContentCell.swift
//  SearchApp
//
//  Created by Олег Романов on 06.04.2024.
//

import UIKit

final class ContentCell: UICollectionViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        static let posterImageViewTopInset: CGFloat = 16
        
        static let trackAndArtistStackViewTopInset: CGFloat = 8
        static let trackAndArtistStackViewLeadingTrailingInset: CGFloat = 8
        
        static let separatorViewTopInset: CGFloat = 8
        static let separatorViewLeadingTrailingInset: CGFloat = 8
        static let separatorViewHeight: CGFloat = 2
        
        static let kindAndReleaseDateStackViewTopInset: CGFloat = 8
        static let kindAndReleaseDateStackViewBottomInset: CGFloat = -16
        static let kindAndReleaseDateStackViewLeadingTrailingInset: CGFloat = 8
        
        static let contentViewCornerRadius: CGFloat = 8
        
        static let trackNameLabelNumberOfLines: Int = 2
        static let trackNameLabelTextAlignment: NSTextAlignment = .center
        static let trackNameLabelFont: UIFont = .systemFont(ofSize: 20, weight: .medium)
        
        static let artistNameLabelFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
        static let artistNameLabelTextColor: UIColor = .gray
        
        static let separatorViewColor: UIColor = .systemGray5
        
        static let kindLabelTextColor: UIColor = .lightGray
        
        static let trackPriceLabelFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let trackPriceLabelTextColor: UIColor = .darkGray
        
        static let trackAndArtistStackViewAxis: NSLayoutConstraint.Axis = .vertical
        static let trackAndArtistStackViewAlignment: UIStackView.Alignment = .center
        static let trackAndArtistStackViewSpacing: CGFloat = 8
        
        static let kindAndReleaseDateStackViewAxis: NSLayoutConstraint.Axis = .vertical
        static let kindAndReleaseDateStackViewAlignment: UIStackView.Alignment = .center
        static let kindAndReleaseDateStackViewSpacing: CGFloat = 8
    }
    
    // MARK: Instance Properties
    
    private lazy var posterImageView: URLImageView = {
        let imageView = URLImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constants.trackNameLabelNumberOfLines
        label.textAlignment = Constants.trackNameLabelTextAlignment
        label.font = Constants.trackNameLabelFont
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.artistNameLabelFont
        label.textColor = Constants.artistNameLabelTextColor
        return label
    }()
    
    private lazy var kindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.kindLabelTextColor
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackAndArtistStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel])
        stackView.axis = Constants.trackAndArtistStackViewAxis
        stackView.alignment = Constants.trackAndArtistStackViewAlignment
        stackView.spacing = Constants.trackAndArtistStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.separatorViewColor
        return view
    }()
    
    private lazy var kindAndReleaseDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [kindLabel, releaseDateLabel])
        stackView.axis = Constants.kindAndReleaseDateStackViewAxis
        stackView.alignment = Constants.kindAndReleaseDateStackViewAlignment
        stackView.spacing = Constants.kindAndReleaseDateStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        kindLabel.text = nil
        releaseDateLabel.text = nil
    }
    
    // MARK: Setup
    
    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(trackAndArtistStackView)
        contentView.addSubview(separatorView)
        contentView.addSubview(kindAndReleaseDateStackView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.posterImageViewTopInset),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            trackAndArtistStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Constants.trackAndArtistStackViewTopInset),
            trackAndArtistStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.trackAndArtistStackViewLeadingTrailingInset),
            trackAndArtistStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.trackAndArtistStackViewLeadingTrailingInset),
            
            separatorView.topAnchor.constraint(equalTo: trackAndArtistStackView.bottomAnchor, constant: Constants.separatorViewTopInset),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.separatorViewLeadingTrailingInset),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.separatorViewLeadingTrailingInset),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorViewHeight),
            
            kindAndReleaseDateStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.kindAndReleaseDateStackViewTopInset),
            kindAndReleaseDateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.kindAndReleaseDateStackViewLeadingTrailingInset),
            kindAndReleaseDateStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.kindAndReleaseDateStackViewLeadingTrailingInset),
            kindAndReleaseDateStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.kindAndReleaseDateStackViewBottomInset)
        ])
    }
    
    // MARK: Instance Methods
    
    func configure(with item: MediaContentListViewModel) {
        guard let url = URL(string: item.artWorkUrl) else { return }
        posterImageView.loadImage(from: url)
        trackNameLabel.text = item.trackName
        artistNameLabel.text = item.artistName
        kindLabel.text = item.kind
        releaseDateLabel.text = item.releaseDate
    }
}
