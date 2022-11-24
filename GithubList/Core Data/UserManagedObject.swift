//
//  GithubUser+CoreData.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import Foundation
import CoreData

extension UserManagedObject{

    internal func update(user: User, includeNotes: Bool = true) {
        loginName = user.loginName
        userId = Int32(user.id)
        avatarURL = user.avatarURL
        profileURL = user.profileURL
        starredURL = user.starredURL
        if includeNotes{
            notes = user.notes
        }
        name = user.name
        company = user.company
        blog = user.blog
        location = user.location
        email = user.email
        followerCount = Int32(user.followerCount ?? 0)
        followingCount = Int32(user.followingCount ?? 0)
    }
}
