//
//  User+ProfileCheck.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

extension User{
    ///Check if profile data already available in the current user
    func isProfileAvailable() -> Bool{
        if name != nil || email != nil{
            return true
        }
        return false
    }
}
