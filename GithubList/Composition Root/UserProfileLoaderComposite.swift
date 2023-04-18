//
//  UserProfileLoaderComposite.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

public class UserProfileLoaderComposite: UserProfileLoader{
    private let mainLoader: UserProfileLoader
    private let fallbackLoader: UserProfileLoader

    public init(mainLoader: UserProfileLoader, fallbackLoader: UserProfileLoader) {
        self.mainLoader = mainLoader
        self.fallbackLoader = fallbackLoader
    }
    
    public func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        mainLoader.loadUserProfile(loginName: loginName) {[weak self] result in
            guard let self else {return}
            if let user = try? result.get(), self.isProfileAvailable(user){
                completion(.success(user))
            }else{
                self.fallbackLoader.loadUserProfile(loginName: loginName, completion: completion)
            }
        }
    }
    
    func isProfileAvailable(_ user: User) -> Bool{
        if user.name != nil || user.email != nil{
            return true
        }
        return false
    }
    
}
