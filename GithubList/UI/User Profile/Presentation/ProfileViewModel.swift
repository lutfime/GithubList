//
//  ProfileViewModel.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import UIKit
import CoreData

class ProfileViewModel: ObservableObject {
    
    private let loader: UserProfileLoader
    var onUserNeedSave: ((User) -> ())?
    
    private var isLoading = false
    
    @Published var userProfileViewModel: UserProfileViewModel!
    private(set) var user: User!
    
    init(loader: UserProfileLoader) {
        self.loader = loader
    }
    
    func loadUserProfile(loginName: String){
        if isLoading{
            return
        }
        
        isLoading = true
        loader.loadUserProfile(loginName: loginName) {[weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let user):
                self.user = user
                self.userProfileViewModel = user.toModel()
            case .failure:
                ()
            }
            self.isLoading = false
        }
    }
    
    func saveNotes(_ notes: String) {
        if let user{
            user.notes = notes
            onUserNeedSave?(user)
        }
    }
    
}

private extension User{
    func toModel() -> UserProfileViewModel {
        let model = UserProfileViewModel(loginName:loginName, name: name, followerCount: followerCount ?? 0, followingCount: followingCount ?? 0, company: company, blog: blog, notes: notes)
        return model
    }
}
