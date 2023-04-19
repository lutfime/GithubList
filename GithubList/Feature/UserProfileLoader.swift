//
//  UserProfileLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

public protocol UserProfileLoader{
    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void)
}
