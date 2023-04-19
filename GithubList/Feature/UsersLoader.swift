//
//  UsersLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

public protocol UsersLoader {
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void)
}
