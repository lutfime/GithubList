//
//  MainQueueDispatchDecorator.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import UIKit

///This class is used to dispatch from any thread to main thread
final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: UsersLoader where T == UsersLoader{
    func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        decoratee.loadGithubUsers(startUserIndex: startUserIndex) {[weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: UserProfileLoader where T == UserProfileLoader{
    func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        decoratee.loadUserProfile(loginName: loginName) {[weak self] result in
            self?.dispatch { completion(result) }

        }
    }
}

extension MainQueueDispatchDecorator: ImageLoader where T == ImageLoader{
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        decoratee.loadImage(url) {[weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
