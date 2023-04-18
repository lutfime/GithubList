//
//  UserProfileLoaderComposite.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

public class UserProfileLoaderComposite: UserProfileLoader{
    private let remoteLoader: UserProfileLoader
    private let localLoader: UserProfileLoader

    public init(remoteLoader: UserProfileLoader, localLoader: UserProfileLoader) {
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
    }
    
    public func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        localLoader.loadUserProfile(loginName: loginName) {result in
            let localUser = try? result.get()
            if let localUser{
                //Show local result first, even if profile not loaded yet
                completion(.success(localUser))
                if !localUser.isProfileAvailable(){
                    self.remoteLoader.loadUserProfile(loginName: loginName, completion: {[weak self] result in
                        guard let self else {return}
                        do{
                            let remoteUser = try result.get()
                            let user = self.combine(localUser: localUser, remoteUser: remoteUser)
                            completion(.success(user))
                        }catch{
                            completion(.failure(error))
                        }
                    })

                }
            }else{
                self.remoteLoader.loadUserProfile(loginName: loginName, completion: completion)
            }
        }
    }
    
    public func combine(localUser: User, remoteUser: User) -> User{
        localUser.name = remoteUser.name
        localUser.company = remoteUser.company
        localUser.blog = remoteUser.blog
        localUser.location = remoteUser.location
        localUser.email = remoteUser.email
        localUser.followerCount = remoteUser.followerCount
        localUser.followingCount = remoteUser.followingCount
        return localUser
    }
}
