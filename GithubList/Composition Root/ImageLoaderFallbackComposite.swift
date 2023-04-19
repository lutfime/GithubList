//
//  ImageLoaderFallbackComposite.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import UIKit

public class ImageLoaderFallbackComposite: ImageLoader{
    private let mainLoader: ImageLoader
    private let fallbackLoader: ImageLoader

    public init(mainLoader: ImageLoader, fallbackLoader: ImageLoader) {
        self.mainLoader = mainLoader
        self.fallbackLoader = fallbackLoader
    }
    
    public func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        mainLoader.loadImage(url) {[weak self] result in
            if let image = try? result.get(){
                completion(.success(image))
            }else{
                self?.fallbackLoader.loadImage(url, completion: completion)
            }
        }
    }
    
}
