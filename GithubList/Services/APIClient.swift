//
//  APIClient.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit

protocol APIClientProtocol {
    func fetchGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void)
    func fetchUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void)
}

class APIClient: APIClientProtocol {
    
    var baseURL = "https://api.github.com/"
    
    ///Use global var for session, so all network request will use 1 connection only
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 1
        let session = URLSession(configuration: config)
        return session
    }()
    
    ///Fetch github users
    func fetchGithubUsers(startUserIndex: Int = 0, completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: baseURL + "users?since=\(startUserIndex)")!
        let task = APIClient.session.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
              DispatchQueue.main.async {
                  completion(.failure(error))
              }
            return
          }
          
          if let data = data, let users = try? JSONDecoder().decode([User].self, from: data) {
              DispatchQueue.main.async {
                  completion(.success(users))
              }
          }
        })
        task.resume()
    }
    
    ///Fetch github user profile
    func fetchUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: baseURL + "users/\(loginName)")!
        let task = APIClient.session.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
              DispatchQueue.main.async {
                  completion(.failure(error))
              }
            
            return
          }
          
          if let data = data, let user = try? JSONDecoder().decode(User.self, from: data) {
              DispatchQueue.main.async {
                  completion(.success(user))
              }
          }
        })
        task.resume()
      }
}
