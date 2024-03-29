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
    private let imageLoader: () -> ImageLoader
    
    private(set) var filterKey: String!
    private(set) var users = [User]()
    private(set) var userViewModels = [UserCellViewModel]()
    private(set) var isLoading = false
    
    public var onListLoad: Observer<[UserCellViewModel]>?
    public var onLoadingNextPage: Observer<Bool>?
    public var onError: Observer<String>?


    
    public init(loader: UsersLoader, imageLoader: @escaping () -> ImageLoader) {
        self.loader = loader
        self.imageLoader = imageLoader
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
            
            switch result{
            case .success(let users):
                if nextPage{
                    self.users.append(contentsOf: users)
                }else{
                    self.users = users
                }
                let imageLoader = self.imageLoader
                self.userViewModels = users.map({$0.toCellModel(imageLoader: imageLoader())})
                self.updateFilteredUsers(with: self.filterKey)
            case .failure:
                self.onError?("Unknown error when loading")
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
    func toCellModel(imageLoader: ImageLoader) -> UserCellViewModel{
        let model = UserCellViewModel(imageLoader:imageLoader, loginName: loginName, avatarURL: avatarURL, profileURL: profileURL, notes: notes)
        return model
    }
}
