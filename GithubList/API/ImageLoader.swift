//
//  ImageLoader.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit
import Combine

class ImageLoader: ObservableObject {
    static let shared = ImageLoader()
    
    private var runningRequests = [UUID: URLSessionDataTask]()
    private var uuidMap = [UIImageView: UUID]()
    
    @Published var updatedImage: UIImage!
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 1
        let session = URLSession(configuration: config)
        return session
    }()
    
    init(){
        
    }
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        _ = ImageLoader.shared.loadImage(url) { result in
            switch result {
            case .success(let image):
                self.updatedImage = image
            case .failure(let failure):
                ()
            }
        }
    }
    
    ///Load image using url, then map the UIImageView so it can be cancelled if needed from the same image view.
    func loadImage(_ url: URL, imageView: UIImageView, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        var uuid = uuidMap[imageView]
        if uuid == nil{
            uuid = UUID()
            uuidMap[imageView] = uuid
        }
        
        let task = loadImage(url) { result in
            defer {self.runningRequests.removeValue(forKey: uuid!) }
            completion(result)
        }
        if let task{
            runningRequests[uuid!] = task
        }else{
            runningRequests.removeValue(forKey: uuid!)
        }
    }
    
    ///Load image from given url, get the image from disk if already cached
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask! {
            
        //Get image already saved on disk, if available
        if let image = ImageCacheManager.shared.image(for: url.absoluteString){
            completion(.success(image))
            return nil
        }

        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                if (error as NSError).code == NSURLErrorCancelled {
                    //Do nothing, because cancelled
                    return
                }
                completion(.failure(error))
                return
            }

            if let data = data, let image = UIImage(data: data) {
                //Save the image to disk
                ImageCacheManager.shared.cache(image: image, identifier: url.absoluteString)
                completion(.success(image))
                return
            }
        }
        task.resume()
        return task
    }
    
    ///Cancel load for the image view, this is useful to cancel loading when reusable cell with same image view instance used.
    func cancelLoad(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView]{
            if let request = runningRequests[uuid]{
                request.cancel()
                runningRequests.removeValue(forKey: uuid)
            }
        }
    }
}
