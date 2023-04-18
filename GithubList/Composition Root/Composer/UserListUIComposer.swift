//
//  UserListUIComposer.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import UIKit

class UserListUIComposer{
    public static func userListComposedWith(
        loader: UsersLoader
    ) -> UserListViewController {
        
        let bundle = Bundle(for: UserListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateViewController(identifier: "userList") { coder in
            let viewModel = UserListViewModel(loader: loader)
            return UserListViewController(coder: coder, viewModel: viewModel)
        } as! UserListViewController
        return controller
    }
}