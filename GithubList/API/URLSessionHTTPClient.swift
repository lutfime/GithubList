//
//  URLSessionHTTPClient.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient{
    private let session: URLSession
    
    public init(session: URLSession = .defaultSession) {
        self.session = session
    }
    
    struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result{
                if let error{
                    throw error
                }
                else if let data, let response = response as? HTTPURLResponse{
                    return (data, response)
                }else{
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
    }
}

extension URLSession{
    public static var defaultSession: URLSession {
        ///All network request will use 1 connection only
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 1
        let session = URLSession(configuration: config)
        return session
    }
}
