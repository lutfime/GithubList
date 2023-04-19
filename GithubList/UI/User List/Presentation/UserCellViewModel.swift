//
//  UserCellViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit

public struct UserCellViewModel: Hashable {
    let imageLoader: ImageLoader
    
    public var loginName: String!
    public var detail: String!
    
    public var avatarURL: String!
    public var profileURL: String!
    public var notes: String!
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(loginName)
    }
    
    public static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        if lhs.loginName == rhs.loginName, lhs.detail == rhs.detail, lhs.avatarURL == rhs.avatarURL, lhs.profileURL == rhs.profileURL, lhs.notes == rhs.notes{
            return true
        }
        return false
    }
    
}

