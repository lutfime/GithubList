//
//  User.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit

@objcMembers
class User: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case loginName = "login"
        case avatarURL = "avatar_url"
        case profileURL = "url"
        case starredURL = "starred_url"
        
        case name = "name"
        case company = "company"
        case blog = "blog"
        case location = "location"
        case email = "email"
        case followerCount = "followers"
        case followingCount = "following"
    }
    
    var loginName: String!
    var id: Int = -1
    var avatarURL: String!
    var profileURL: String!
    var starredURL: String!
    var notes: String!
    
    var name: String!
    var company: String!
    var blog: String!
    var location: String!
    var email: String!
    var followerCount: Int!
    var followingCount: Int!
    
}
