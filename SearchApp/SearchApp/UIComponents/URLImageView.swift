//
//  URLImageView.swift
//  SearchApp
//
//  Created by Олег Романов on 07.04.2024.
//

import UIKit

class URLImageView: UIImageView {
    
    // MARK: Instance Properties
    
    private var currentURL: URL?
    private var imageLoadTask: URLSessionDataTask?
    
    // MARK: Instance Methods
    
    func loadImage(from url: URL) {
        imageLoadTask?.cancel()
        
        currentURL = url
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            if let data = try? Data(contentsOf: url) {
                if self.currentURL == url {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
