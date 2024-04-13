//
//  UIViewController + Extensions.swift
//  SearchApp
//
//  Created by Олег Романов on 08.04.2024.
//

import UIKit

extension UIViewController {
    
    func showListLoading() {
        hideListLoading()
        guard let window = getKeyWindow(), let nav = window.rootViewController as? UINavigationController else {
            assertionFailure("Can't get keyWindow")
            return
        }
        let point = CGPoint(x: .zero, y: nav.navigationBar.frame.height + nav.view.safeAreaInsets.top)
        
        let loadingView = ListLoadingView(frame: CGRect(origin: point, size: obtainListLoadingViewSize()))
        window.addSubview(loadingView)
        window.bringSubviewToFront(loadingView)
        
    }
    
    func hideListLoading() {
        guard let loadingView = obtainListLoadingView() else {
            return
        }
        loadingView.removeFromSuperview()
    }
    
    func obtainListLoadingView() -> ListLoadingView? {
        return getKeyWindow()?.subviews.first(where: { $0 is ListLoadingView }) as? ListLoadingView
    }
    
    func obtainListLoadingViewSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 5.0)
    }
    
    private func getKeyWindow() -> UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        return window
    }
}

extension UIViewController {
    func showErrorAlert(message: String) {
        guard let window = getKeyWindow() else {
            assertionFailure("Can't get keyWindow")
            return
        }

        let errorView = BottomErrorView(text: message)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(errorView)
        window.bringSubviewToFront(errorView)

        NSLayoutConstraint.activate([
            errorView.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            errorView.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            errorView.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            errorView.heightAnchor.constraint(equalToConstant: 80.0)
        ])

        errorView.show()
    }
}
