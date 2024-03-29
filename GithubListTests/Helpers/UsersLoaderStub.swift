//
//  UsersLoaderMock.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation
import GithubList


class UsersLoaderStub: UsersLoader{
    let users: [User]
    
    init(users: [User] = UsersLoaderStub.defaultUsers) {
        self.users = users
    }
    
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[GithubList.User], Error>) -> Void) {
        completion(.success(users))
    }
    
    static var defaultUsers: [User] = {
        let user = User()
        user.loginName = "a name"
        user.avatarURL = "a url"
        user.notes = "a note"
        
        let user2 = User()
        user2.loginName = "other name"
        user2.avatarURL = "other url"
        user2.notes = "other note"

        
        let user3 = User()
        user3.loginName = "another name"
        user3.avatarURL = "another url"
        user3.notes = "another note"

        return [user, user2, user3]
    }()
}
