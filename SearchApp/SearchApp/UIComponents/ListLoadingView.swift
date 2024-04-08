//
//  ListLoadingView.swift
//  SearchApp
//
//  Created by Олег Романов on 08.04.2024.
//

import UIKit

final class ListLoadingView: BaseLoadingView {
    
    // MARK: Constants
    
    private enum Constants {
        static let animatedLength: CGFloat = 125.0
        static let lineWidth: CGFloat = 5.0
        static let layerOpacity: Float = 1.0
        static let animationDuration: TimeInterval = 1.25
    }
    
    // MARK: Properties
    
    private var containerLineLayer = CAShapeLayer()
    private var animatedLineLayer = CAShapeLayer()
    
    // MARK: States
    
    private let positionStates = [
        State(time: 0.0, value: CGPoint(x: -100.0, y: .zero)),
        State(time: 0.25, value: CGPoint(x: 0.0, y: .zero)),
        State(time: 0.5, value: CGPoint(x: 150.0, y: .zero)),
        State(time: 0.75, value: CGPoint(x: 300.0, y: .zero)),
        State(time: 1.0, value: CGPoint(x: 450.0, y: .zero))
    ]
    
    // MARK: Setup
    
    override func addLayers() {
        drawLine(layer: &containerLineLayer,
                 color: UIColor.secondarySystemBackground.cgColor,
                 start: .init(x: -5.0, y: .zero),
                 end: .init(x: UIScreen.main.bounds.width + 5.0, y: .zero))
        layer.addSublayer(containerLineLayer)
        
        drawLine(layer: &animatedLineLayer,
                 color: UIColor.systemGreen.cgColor,
                 start: .zero,
                 end: .init(x: Constants.animatedLength, y: .zero))
        layer.addSublayer(animatedLineLayer)
    }
    
    // MARK: Animate

    override func animate() {
        animateKeyPath(keyPath: "position",
                       duration: Constants.animationDuration,
                       times: positionStates.map { $0.time },
                       values: positionStates.map { $0.value },
                       layer: animatedLineLayer)
    }
    
    // MARK: Helpers
    
    private func drawLine(layer: inout CAShapeLayer, color: CGColor, start: CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        layer.position = .zero
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineCap = .round
        layer.lineWidth = Constants.lineWidth
        layer.opacity = Constants.layerOpacity
    }
}
