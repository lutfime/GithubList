//
//  UserListViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit
import CoreData

public protocol EventDelegate: AnyObject {
    func handleNoInternetConnection()
    func handleInternetConnectionRestored()
}

public class UserListViewModel: NSObject {
    public typealias Observer<T> = (T) -> Void
    
    public weak var delegate: EventDelegate?

    private let apiService: UsersLoader
    
    private(set) var filterKey: String!
    private(set) var users = [User]()
    private(set) var userViewModels = [UserCellViewModel]()
    private var isLoading = false
    let reachability = try! Reachability()
    
    public var onListLoad: Observer<[UserCellViewModel]>?
    
    public init(service: UsersLoader) {
        self.apiService = service
        
        super.init()
        setupReachability()
    }
    
    func setupReachability(){
        reachability.whenReachable = { reachability in
            self.delegate?.handleInternetConnectionRestored()
            //Retry loading when internet restored
            self.loadData()
        }
        reachability.whenUnreachable = { _ in
            self.delegate?.handleNoInternetConnection()
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
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
        }
        //Load new data from API, then merge with core data
        apiService.loadGithubUsers(startUserIndex: startUserIndex) {[weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let users):
                if nextPage{
                    self.users.append(contentsOf: users)
                }else{
                    self.users = users
                }
                //Merge data from API or create new one if not available in core data. Do not save not because load only available locally from core data
//                for user in users{
//                    self.dataProvider.createOrUpdate(user: user, includeNotes: false)
//                }
                //Save core data
//                self.dataProvider.coreDataStack.saveContext()
                self.userViewModels = users.map({$0.toCellModel()})
                self.updateFilteredUsers(with: self.filterKey)
                self.isLoading = false
            case .failure(let _):
                self.isLoading = false
            }
        }
    }
    
    ///Update filtered users with given key
    public func updateFilteredUsers(with key: String!){
        filterKey = key
        var filtered = userViewModels
        if let filterKey = filterKey?.lowercased(){
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
