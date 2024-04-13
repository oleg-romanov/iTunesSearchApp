//
//  BottomErrorView.swift
//  SearchApp
//
//  Created by Олег Романов on 13.04.2024.
//

import UIKit

final class BottomErrorView: UIView {

    // MARK: Constants

    private enum Constants {
        static let topOffset: CGFloat = 100.0
        static let animationsDuration: TimeInterval = 0.15
        static let showDuration: TimeInterval = 3.0
        static let containerViewCornerRadius: CGFloat = 8
        
        static let textLabelTopInset: CGFloat = 16
        static let textLabelBottomInset: CGFloat = -16
        static let textLabelLeadingInset: CGFloat = 16
        static let textLabelTrailingInset: CGFloat = -16
    }
    
    // MARK: Instance Properties
    
    private var containerViewBottomConstraint: NSLayoutConstraint?

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = Constants.containerViewCornerRadius
        view.addSubview(textLabel)
        return view
    }()
    
    // MARK: Initializers
    
    init(text: String) {
        super.init(frame: .zero)
        textLabel.text = text
        setup()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onGestureRecognizer))
        containerView.addGestureRecognizer(tapGesture)
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onGestureRecognizer))
        swipeUpGestureRecognizer.direction = .down
        containerView.addGestureRecognizer(swipeUpGestureRecognizer)
    }
    
    private func addSubviews() {
        addSubview(containerView)
    }

    // MARK: Constraints

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.textLabelTopInset),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.textLabelLeadingInset),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.textLabelTrailingInset),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Constants.textLabelBottomInset),
            
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.topOffset)
        containerViewBottomConstraint?.isActive = true
    }
    
    // MARK: Show and Hide

    func show() {
        UIView.animate(withDuration: Constants.animationsDuration,
                       delay: .zero,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            self.containerViewBottomConstraint?.constant = 0
            self.layoutIfNeeded()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.showDuration) { [weak self] in
            self?.hide()
        }
    }

    private func hide() {
        UIView.animate(withDuration: Constants.animationsDuration,
                       delay: .zero,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            self.containerViewBottomConstraint?.constant = Constants.topOffset
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    // MARK: Actions
    
    @objc private func onGestureRecognizer() {
        hide()
    }
}
