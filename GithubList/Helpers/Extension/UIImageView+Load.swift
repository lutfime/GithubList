//
//  UIImageView+Load.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit

extension UIImageView{
    func loadImage(for url: URL, invertedColor: Bool = false) {
        ImageLoader.shared.cancelLoad(for: self)
        ImageLoader.shared.loadImage(url, imageView: self) { result in
            switch result {
            case .success(let image):
                var theImage = image
                DispatchQueue.main.async {
                    if invertedColor{
                        theImage = theImage.inverted()
                    }
                    self.image = theImage
                }
            case .failure(let error):
                ()//Do nothing
            }
        }
    }
}
