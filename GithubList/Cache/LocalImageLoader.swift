//
//  LocalImageLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import UIKit

public class LocalImageLoader: ImageLoader{

    struct NotFound: Error {}

    public func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = image(for: url.lastPathComponent){
            completion(.success(image))
        }else{
            completion(.failure(NotFound()))
        }
    }
    
    private func image(for identifier: String) -> UIImage! {
        let newIdentifier = identifier.replacingOccurrences(of: "/", with: "_", options: [])
        let dir = cacheDirectory()
        let path = dir.appending("/Images")
        let filePath = path.appending("/" + newIdentifier)
        if let data = NSData(contentsOfFile: filePath){
            let image = UIImage(data: data as Data)
            return image
        }
        return nil
    }
    
    // MARK: Save Cache
    
    public func saveImage(_ image: UIImage, url: URL){
        let identifier = url.lastPathComponent
        cache(image: image, identifier: identifier)
    }
    
    ///Cache the image to disk
    private func cache(image: UIImage, identifier: String) {
        let newIdentifier = identifier.replacingOccurrences(of: "/", with: "_", options: [])
        
        let dir = cacheDirectory()
        let path = dir.appending("/Images")
        if !FileManager.default.fileExists(atPath: path){
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }
        let filePath = path.appending("/" + newIdentifier)
        let data = image.pngData()
        try? data?.write(to: URL(fileURLWithPath: filePath))
    }
    
    // MARK: Persistence

    func cacheDirectory() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        return documentsPath
    }
    
}
 
