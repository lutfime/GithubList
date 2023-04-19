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
        //Here we check if the data is different only set the var in the managed object. If we just set it seems Core Data marking it as hasChanged
        if loginName != user.loginName{
            loginName = user.loginName
        }
        if userId != Int32(user.id){
            userId = Int32(user.id)
        }
        if avatarURL != user.avatarURL{
            avatarURL = user.avatarURL
        }
        if profileURL != user.profileURL{
            profileURL = user.profileURL
        }
        if starredURL != user.starredURL{
            starredURL = user.starredURL
        }
        
        if includeNotes, notes != user.notes{
            notes = user.notes
        }
        if name != user.name{
            name = user.name
        }
        if company != user.company{
            company = user.company
        }
        if blog != user.blog{
            blog = user.blog
        }
        if location != user.location{
            location = user.location
        }
        if email != user.email{
            email = user.email
        }
        if followerCount != Int32(user.followerCount ?? 0){
            followerCount = Int32(user.followerCount ?? 0)
        }
        if followingCount != Int32(user.followingCount ?? 0){
            followingCount = Int32(user.followingCount ?? 0)
        }
    }
}
