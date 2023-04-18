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
    
    let baseURL = "https://api.github.com/"
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    ///Fetch github users
    func loadGithubUsers(startUserIndex: Int = 0, completion: @escaping (Result<[User], Error>) -> Void) {
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
    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
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
