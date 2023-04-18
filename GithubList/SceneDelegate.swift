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
        let remoteLoader = APILoader(client: URLSessionHTTPClient()).cachingTo(coreDataStack)
        let compositeLoader = UsersLoaderComposite(localLoader: localLoader, remoteLoader: remoteLoader)
        
        let userListVC = UserListUIComposer.userListComposedWith(loader: compositeLoader, selection: showUserProfile)

        navigationController.viewControllers = [userListVC]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showUserProfile(_ viewModel: UserCellViewModel){
        var profileView = UserProfileView()
        profileView.loginName = viewModel.loginName
        profileView.avatarURL = viewModel.avatarURL
        //Open selected user profile view
        let vc = UIHostingController(rootView: profileView)
        navigationController.pushViewController(vc, animated: true)
    }

}

