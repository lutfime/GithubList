//
//  UsersLoaderDelayDecorator.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import Foundation

///This class is used to cache result from UsersLoader
public class UsersLoaderDelayDecorator: UsersLoader{
    private let loader: UsersLoader
    private let delay: CGFloat
    
    public init(loader: UsersLoader, delay: CGFloat) {
        self.loader = loader
        self.delay = delay
    }
    
    public func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        let delay = self.delay
        loader.loadGithubUsers(startUserIndex: startUserIndex) { result in
            //Delay if load more for demo purpose
            if startUserIndex > 0{
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    completion(result)
                }
            }else{
                completion(result)
            }
            
        }
    }
}

extension UsersLoader{
    ///Delay completion for demo purpose, in this case to show load more indicator
    func delayingCompletion(by delay: CGFloat) -> UsersLoader{
        return UsersLoaderDelayDecorator(loader: self, delay: delay)
    }
}
