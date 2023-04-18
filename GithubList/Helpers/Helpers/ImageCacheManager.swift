//
//  CacheManager.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 23/11/2022.
//

import UIKit

///Used to save image to local disk
public class ImageCacheManager: NSObject {
    public static let shared = ImageCacheManager()

    // MARK: Get Cache
    
    ///Get image already saved to disk, if available
    public func image(for identifier: String) -> UIImage! {
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
    
    ///Cache the image to disk
    public func cache(image: UIImage, identifier: String) {
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
