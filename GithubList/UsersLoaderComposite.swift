//
//  UsersLoaderComposite.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import Foundation

public class UsersLoaderComposite: UsersLoader{
    private let localLoader: UsersLoader
    private let remoteLoader: UsersLoader
    
    private let syncQueue: DispatchQueue = .init(label: "Image Upload Sync Queue",
                                         qos: .userInitiated,
                                         attributes: [],
                                         autoreleaseFrequency: .workItem)


    public init(localLoader: UsersLoader, remoteLoader: UsersLoader) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }
    
    public func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        var localResult: Result<[User], Error>?
        var remoteResult: Result<[User], Error>?
        
        func completeWhenBothLoaderCompleted(){
            if let localResult, let remoteResult{
                do{
                    let users = combineUsers(try localResult.get(), remoteUsers: try remoteResult.get())
                    completion(.success(users))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        localLoader.loadGithubUsers(startUserIndex: startUserIndex) { result in
            localResult = result
            completeWhenBothLoaderCompleted()
        }
        remoteLoader.loadGithubUsers(startUserIndex: startUserIndex) { result in
            remoteResult = result
            completeWhenBothLoaderCompleted()

        }
    }
    
    private func combineUsers(_ localUsers: [User], remoteUsers: [User]) -> [User]{
        //Combine local and remote users using user index
        var updatedUsers = localUsers
        updatedUsers.append(contentsOf: remoteUsers.filter({ remoteUser in
            let contains = localUsers.contains(where: { localUser in
                return localUser.id == remoteUser.id
            })
            return !contains
        }))
        return updatedUsers
    }
    
}