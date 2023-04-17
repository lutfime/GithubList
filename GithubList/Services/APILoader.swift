//
//  APIClient.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit

protocol UsersLoader {
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void)
}

protocol UserProfileLoader{
    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void)
}

typealias APIClientProtocol = UsersLoader & UserProfileLoader

class APILoader: UsersLoader, UserProfileLoader{
    
    var baseURL = "https://api.github.com/"
    
    ///Use global var for session, so all network request will use 1 connection only
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 1
        let session = URLSession(configuration: config)
        return session
    }()
    
    ///Fetch github users
    func loadGithubUsers(startUserIndex: Int = 0, completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: baseURL + "users?since=\(startUserIndex)")!
        let task = APILoader.session.dataTask(with: url, completionHandler: { (data, response, error) in
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
    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: baseURL + "users/\(loginName)")!
        let task = APILoader.session.dataTask(with: url, completionHandler: { (data, response, error) in
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
