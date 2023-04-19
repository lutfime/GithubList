//
//  UserCellViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit

public struct UserCellViewModel: Hashable {
    let imageLoader: ImageLoader
    
    public let loginName: String
    
    public let avatarURL: String?
    public let profileURL: String?
    public var notes: String?
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(loginName)
    }
    
    public static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        if lhs.loginName == rhs.loginName, lhs.avatarURL == rhs.avatarURL, lhs.profileURL == rhs.profileURL, lhs.notes == rhs.notes{
            return true
        }
        return false
    }
    
}

