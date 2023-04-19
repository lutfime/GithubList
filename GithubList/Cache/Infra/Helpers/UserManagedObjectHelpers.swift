//
//  UserManagedObjectHelpers.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import Foundation

extension UserManagedObject{
    func toModel() -> User{
        let user = User()
        user.id = Int(userId)
        user.loginName = loginName
        user.avatarURL = avatarURL
        user.profileURL = profileURL
        user.starredURL = starredURL
        user.notes = notes
        user.name = name
        user.company = company
        user.blog = blog
        user.location = location
        user.email = email
        user.followerCount = Int(followerCount)
        user.followingCount = Int(followingCount)
        return user
    }
}
