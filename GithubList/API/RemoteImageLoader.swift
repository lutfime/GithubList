//
//  RemoteImageLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import UIKit

class RemoteImageLoader: ImageLoader{
    let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    private static var OK_200: Int { return 200 }
    
    struct InvalidData: Error {}
    
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        client.get(from: url) { result in
            do{
                let (data, response) = try result.get()
                if response.statusCode == RemoteImageLoader.OK_200, let image = UIImage(data: data){
                    completion(.success(image))
                }else{
                    completion(.failure(InvalidData()))
                }
            }catch{
                completion(.failure(error))
            }
        }
    }
    
}

