//
//  UserListViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit
import CoreData

public class UserListViewModel: NSObject {
    public typealias Observer<T> = (T) -> Void
    
    private let loader: UsersLoader
    
    private(set) var filterKey: String!
    private(set) var users = [User]()
    private(set) var userViewModels = [UserCellViewModel]()
    private(set) var isLoading = false
    
    public var onListLoad: Observer<[UserCellViewModel]>?
    public var onLoadingNextPage: Observer<Bool>?

    
    public init(loader: UsersLoader) {
        self.loader = loader
    }
    
    ///Load data from local if available, then load the data from API
    public func loadData(nextPage: Bool = false){
        if isLoading{
            return
        }
        
        isLoading = true
        
        var startUserIndex = 0
        if nextPage, let lastUser = users.last{
            startUserIndex = lastUser.id
            onLoadingNextPage?(true)
        }
        
        //Load new data from API, then merge with core data
        loader.loadGithubUsers(startUserIndex: startUserIndex) {[weak self] result in
            guard let self else {return}
            
            if let users = try? result.get(){
                if nextPage{
                    self.users.append(contentsOf: users)
                }else{
                    self.users = users
                }
                self.userViewModels = users.map({$0.toCellModel()})
                self.updateFilteredUsers(with: self.filterKey)
            }
            
            self.isLoading = false
            self.onLoadingNextPage?(false)
        }
    }
    
    ///Update filtered users with given key
    public func updateFilteredUsers(with key: String!){
        filterKey = key
        var filtered = userViewModels
        if let filterKey = filterKey?.lowercased(), filterKey.count > 0{
            filtered = userViewModels.filter { user in
                if user.loginName.lowercased().contains(filterKey){
                    return true
                }
                if let notes = user.notes, notes.lowercased().contains(filterKey){
                    return true
                }
                return false
            }
        }
        onListLoad?(filtered)
    }
    
    ///Check if the data is being filtered
    func isBeingFiltered() -> Bool{
        if let filterKey, filterKey.count > 0{
            return true
        }
        return false
    }
    
}

extension User{
    func toCellModel() -> UserCellViewModel{
        let model = UserCellViewModel(loginName: loginName, detail: nil, avatarURL: avatarURL, profileURL: profileURL, notes: notes)
        return model
    }
}
