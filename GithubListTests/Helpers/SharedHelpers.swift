//
//  SharedHelpers.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import GithubList

func makeUser(id: Int, loginName: String, notes: String? = nil) -> User{
    let user = User()
    user.id = id
    user.loginName = loginName
    user.notes = notes
    return user
}
