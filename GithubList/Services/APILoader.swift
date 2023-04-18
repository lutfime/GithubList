//
//  APIClient.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit

public protocol UsersLoader {
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void)
}

public protocol UserProfileLoader{
    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void)
}

public typealias APIClientProtocol = UsersLoader & UserProfileLoader

public class APILoader: UsersLoader, UserProfileLoader{
    
    let baseURL = "https://api.github.com/"
    let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    ///Fetch github users
    public func loadGithubUsers(startUserIndex: Int = 0, completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: baseURL + "users?since=\(startUserIndex)")!
        client.get(from: url) { result in
            do{
                let (data, _) = try result.get()
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            }catch{
                completion(.failure(error))
            }
        }
    }
    
    ///Fetch github user profile
    public func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: baseURL + "users/\(loginName)")!
        client.get(from: url) { result in
            do{
                let (data, _) = try result.get()
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            }catch{
                completion(.failure(error))
            }
        }
      }
}
