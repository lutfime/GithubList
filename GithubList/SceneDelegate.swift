//
//  SceneDelegate.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let coreDataStack = AppDelegate.shared.coreDataStack
        let localLoader = LocalLoader(coreDataStack: coreDataStack)
        let remoteLoader = APILoader(client: URLSessionHTTPClient()).cachingUserListTo(coreDataStack)
        let compositeLoader = UsersLoaderComposite(localLoader: localLoader, remoteLoader: remoteLoader)
        
        let userListVC = UserListUIComposer.userListComposedWith(loader: compositeLoader, selection: showUserProfile)

        navigationController.viewControllers = [userListVC]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showUserProfile(_ viewModel: UserCellViewModel){
        let coreDataStack = AppDelegate.shared.coreDataStack
        let localLoader = LocalLoader(coreDataStack: coreDataStack)
        let remoteLoader = APILoader(client: URLSessionHTTPClient())
        let compositeLoader = UserProfileLoaderComposite(remoteLoader: remoteLoader, localLoader: localLoader)
        
        let model = ProfileViewModel(service: compositeLoader)
        var profileView = UserProfileView(viewModel: model)
        profileView.loginName = viewModel.loginName
        profileView.avatarURL = viewModel.avatarURL
        //Open selected user profile view
        let vc = UIHostingController(rootView: profileView)
        navigationController.pushViewController(vc, animated: true)
    }

}

