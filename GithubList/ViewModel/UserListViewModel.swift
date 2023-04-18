//
//  UserListViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit
import CoreData

public protocol EventDelegate: AnyObject {
    func handleDataDidUpdate()
    func handleNoInternetConnection()
    func handleInternetConnectionRestored()
}


public class UserListViewModel: NSObject {
    
    public weak var delegate: EventDelegate?

    private let apiService: APIClientProtocol
    private let dataProvider: UsersProvider
    
    private(set) var filterKey: String!
    private(set) var users = [User]()
    private(set) var filteredUserViewModels = [UserCellViewModel]()
    private var isLoading = false
    let reachability = try! Reachability()
    
    public init(service: APIClientProtocol = APILoader(client: URLSessionHTTPClient()), coreDataStack: CoreDataStack = AppDelegate.shared.coreDataStack) {
        self.apiService = service
        self.dataProvider = UsersProvider(coreDataStack: coreDataStack)
        
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
    
    ///Load data from core data
    func loadLocalData() {
        updateFilteredUsers(with: self.filterKey)
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
                for user in users{
                    self.dataProvider.createOrUpdate(user: user, includeNotes: false)
                }
                //Save core data
                self.dataProvider.coreDataStack.saveContext()
                self.updateFilteredUsers(with: self.filterKey)
                self.isLoading = false
            case .failure(let _):
                self.isLoading = false
            }
        }
    }
    
    ///Update filtered users with given key
    func updateFilteredUsers(with key: String!){
        filterKey = key
        self.filteredUserViewModels = getFilteredUserViewModels(filterKey: key)
        delegate?.handleDataDidUpdate()
    }
    
    
    ///Get filtered user view models from core data
    func getFilteredUserViewModels(filterKey: String! = nil) -> [UserCellViewModel]{
        guard let userManagedObjects = dataProvider.getUsers(filterKey: filterKey) else{
            return []
        }
        var models = [UserCellViewModel]()
        for object in userManagedObjects {
            models.append(createCellModel(user: object))
        }
        return models
    }
    
    func createCellModel(user: UserManagedObject) -> UserCellViewModel {
        var model = UserCellViewModel()
        model.loginName = user.loginName
        model.avatarURL = user.avatarURL
        model.profileURL = user.profileURL
        model.notes = user.notes
        return model
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> UserCellViewModel{
        let model = filteredUserViewModels[indexPath.row]
        return model
    }
    
    ///Check if the data is being filtered
    func isBeingFiltered() -> Bool{
        if let filterKey, filterKey.count > 0{
            return true
        }
        return false
    }
    
}
