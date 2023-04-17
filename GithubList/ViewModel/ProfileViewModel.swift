//
//  ProfileViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import UIKit
import CoreData

class ProfileViewModel: ObservableObject {
    
    private let apiService: APIClientProtocol
    private let dataProvider: UsersProvider
    
    weak var delegate: RequestDelegate?
    private var state: ViewState = .idle {
        didSet {
            if Thread.isMainThread{
                self.delegate?.didUpdate(with: state)
            }else{
                DispatchQueue.main.sync {
                    self.delegate?.didUpdate(with: state)
                }
            }
        }
    }
    
    @Published var userProfileViewModel: UserProfileViewModel!
    private(set) var user: User!
    
    init(service: APIClientProtocol = APILoader(), coreDataStack: CoreDataStack = AppDelegate.shared.coreDataStack) {
        self.dataProvider = UsersProvider(coreDataStack: coreDataStack)
        self.apiService = service
    }
    
    func loadUserProfile(loginName: String){
        switch state{
        case .loading:
            return
        default:
            ()
        }
        
        //Load data from
        var foundUserCoreData: UserManagedObject!
        let stack = AppDelegate.shared.coreDataStack
        let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(UserManagedObject.loginName), loginName)
        fetchRequest.predicate = predicate
        do {
            let results = try stack.mainContext.fetch(fetchRequest)
            if !results.isEmpty {
                foundUserCoreData = results.first
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        //Load user profile
        state = .loading
        apiService.fetchUserProfile(loginName: loginName) { result in
            switch result {
            case .success(let user):
                if let foundUserCoreData{
                    user.notes = foundUserCoreData.notes
                }
                self.user = user
                self.userProfileViewModel = self.getUserProfileViewModel(user: user)
                self.dataProvider.createOrUpdate(user: user)
                //Save core data
                AppDelegate.shared.coreDataStack.saveContext()
                self.state = .success
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    func saveNotes(_ notes: String) {
        if let user{
            print(notes)
            user.notes = notes
            dataProvider.createOrUpdate(user: user)
        }
    }
    
    // MARK:
    
    func getUserProfileViewModel(user: User) -> UserProfileViewModel {
        let model = UserProfileViewModel(loginName:user.loginName, name: user.name, followerCount: user.followerCount ?? 0, followingCount: user.followingCount ?? 0, company: user.company, blog: user.blog, notes: user.notes)
        return model
    }
}
