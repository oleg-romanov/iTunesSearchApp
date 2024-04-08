//
//  BaseLoadingView.swift
//  SearchApp
//
//  Created by Олег Романов on 08.04.2024.
//

import UIKit

class BaseLoadingView: UIView {
    
    // MARK: State struct
    
    struct State {
        let time: TimeInterval
        let value: Any
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        addLayers()
        animate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func addSubviews() { }
    func makeConstraints() { }
    func addLayers() { }
    
    // MARK: Animate
    
    func animate() { }
    
    // MARK: Helpers

    func animateKeyPath(keyPath: String,
                        duration: CFTimeInterval,
                        times: [TimeInterval],
                        values: [Any],
                        layer: CALayer) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = .infinity
        layer.add(animation, forKey: keyPath)
    }
}
