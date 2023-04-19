//
//  ImageLoaderCacheDecorator.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import UIKit

public class ImageLoaderCacheDecorator: ImageLoader{
    private let loader: ImageLoader
    private let cache: LocalImageLoader

    public init(loader: ImageLoader, cache: LocalImageLoader) {
        self.loader = loader
        self.cache = cache
    }
    
    public func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        loader.loadImage(url) {[weak self] result in
            guard let self else {return}
            if let image = try? result.get(){
                self.cache.saveImage(image, url: url)
            }
            completion(result)
        }
    }
}

