//
//  SearchHistoryCell.swift
//  SearchApp
//
//  Created by Олег Романов on 12.04.2024.
//

import UIKit

final class SearchHistoryCell: UITableViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        static let searchIconImageViewImageName: String = "clock.arrow.circlepath"
        static let accessoryViewImageName: String = "chevron.right"
        static let searchIconImageViewTintColor: UIColor = .black
        
        static let clockIconImageViewLeadingInset: CGFloat = 16
        static let clockIconImageViewWidthAndHeight: CGFloat = 20
        
        static let titleLabelTopInset: CGFloat = 16
        static let titleLabelBottomInset: CGFloat = -16
        static let titleLabelLeadingInset: CGFloat = 16
        static let titleLabelTrailingInset: CGFloat = -16
    }
    
    // MARK: Instance Properties
    
    private let clockIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: Constants.searchIconImageViewImageName)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.searchIconImageViewTintColor
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setup() {
        let disclosureIndicator = UIImageView(image: UIImage(systemName: Constants.accessoryViewImageName))
        disclosureIndicator.tintColor = .gray
        accessoryView = disclosureIndicator
        addSuviews()
        makeConstraints()
    }
    
    private func addSuviews() {
        contentView.addSubview(clockIconImageView)
        contentView.addSubview(titleLabel)
    }
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            clockIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            clockIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.clockIconImageViewLeadingInset),
            clockIconImageView.widthAnchor.constraint(equalToConstant: Constants.clockIconImageViewWidthAndHeight),
            clockIconImageView.heightAnchor.constraint(equalToConstant: Constants.clockIconImageViewWidthAndHeight),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.titleLabelTopInset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.titleLabelBottomInset),
            titleLabel.leadingAnchor.constraint(equalTo: clockIconImageView.trailingAnchor, constant: Constants.titleLabelLeadingInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.titleLabelTrailingInset)
        ])
    }
    
    // MARK: Instance Methods
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
