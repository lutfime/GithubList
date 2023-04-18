//
//  User.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit

@objcMembers
public class User: NSObject, Codable {
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
    
    public var loginName: String!
    public var id: Int = -1
    public var avatarURL: String!
    public var profileURL: String!
    public var starredURL: String!
    public var notes: String!
    
    public var name: String!
    public var company: String!
    public var blog: String!
    public var location: String!
    public var email: String!
    public var followerCount: Int!
    public var followingCount: Int!
    
}
