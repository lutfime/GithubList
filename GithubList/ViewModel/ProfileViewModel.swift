//
//  ProfileViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import UIKit
import CoreData

class ProfileViewModel: ObservableObject {
    
    private let apiService: UserProfileLoader
    var onUserNeedSave: ((User) -> ())?
    
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
    
    init(service: UserProfileLoader = APILoader(client: URLSessionHTTPClient())) {
        self.apiService = service
    }
    
    func loadUserProfile(loginName: String){
        switch state{
        case .loading:
            return
        default:
            ()
        }
        
        //Load user profile
        state = .loading
        apiService.loadUserProfile(loginName: loginName) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.userProfileViewModel = self.getUserProfileViewModel(user: user)

                self.state = .success
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    func saveNotes(_ notes: String) {
        if let user{
            user.notes = notes
            onUserNeedSave?(user)
        }
    }
    
    // MARK:
    
    func getUserProfileViewModel(user: User) -> UserProfileViewModel {
        let model = UserProfileViewModel(loginName:user.loginName, name: user.name, followerCount: user.followerCount ?? 0, followingCount: user.followingCount ?? 0, company: user.company, blog: user.blog, notes: user.notes)
        return model
    }
}
