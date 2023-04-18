//
//  SceneDelegate.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit

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
        
        let userListVC = UserListUIComposer.userListComposedWith(loader: compositeLoader)

        navigationController.viewControllers = [userListVC]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

