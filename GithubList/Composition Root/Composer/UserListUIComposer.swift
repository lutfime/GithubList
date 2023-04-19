//
//  UserListUIComposer.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import UIKit

class UserListUIComposer{
    public static func userListComposedWith(
        loader: UsersLoader,
        imageLoader: @escaping () -> ImageLoader,
        selection: @escaping (UserCellViewModel) -> (),
        internetConnectionUpdater: @escaping (InternetConnectionUpdater) -> ()
    ) -> UserListViewController {
        
        let bundle = Bundle(for: UserListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateViewController(identifier: "userList") { coder in
            let viewModel = UserListViewModel(
                loader: MainQueueDispatchDecorator(decoratee: loader),
                imageLoader: imageLoader)
            return UserListViewController(coder: coder, viewModel: viewModel)
        } as! UserListViewController
        controller.selection = selection
        
        let internetUpdater = UserListInternetUpdatedAdapter(userListVC: controller)
        internetConnectionUpdater(internetUpdater)
        
        return controller
    }
}

class UserListInternetUpdatedAdapter: InternetConnectionUpdater{
    let userListVC: UserListViewController
    
    init(userListVC: UserListViewController) {
        self.userListVC = userListVC
    }
    
    func internetConnectionUpdated(_ state: InternetConnectionState) {
        switch state {
        case .connected:
            userListVC.handleInternetConnectionRestored()
        case .notConnected:
            userListVC.handleNoInternetConnection()
        }
    }
}
