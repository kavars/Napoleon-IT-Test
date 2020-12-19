//
//  UIImage+loadImage.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL, complition: @escaping () -> Void) -> URLSessionDownloadTask? {
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] url, response, error in
            if
                error == nil,
                let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            {
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                        complition()
                    }
                }
            }
        }
        
        downloadTask.resume()
        return downloadTask
    }
    
}
