//
//  SceneDelegate.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 17/11/2022.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let navigationController = UINavigationController()
    
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("user-store.sqlite")
    
    private lazy var coreDataStack: CoreDataStack = {
        do {
            return try CoreDataStack(storeURL: localStoreURL)
        }
        catch{
            fatalError("Cannot initialize core data")
        }
    }()
    
    private lazy var usersRepository: UsersRepository = {
        return UsersCoreDataRepository(coreDataStack: coreDataStack)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let localLoader = LocalLoader(usersRepository: usersRepository)
        let remoteLoader = APILoader(client: URLSessionHTTPClient()).cachingUserListTo(coreDataStack)
        let compositeLoader = UsersLoaderComposite(localLoader: localLoader, remoteLoader: remoteLoader)
        
        let userListVC = UserListUIComposer.userListComposedWith(loader: compositeLoader, selection: showUserProfile)

        navigationController.viewControllers = [userListVC]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showUserProfile(_ viewModel: UserCellViewModel){
        let localLoader = LocalLoader(usersRepository: usersRepository)
        let remoteLoader = APILoader(client: URLSessionHTTPClient()).cachingUserProfileTo(coreDataStack)
        let compositeLoader = UserProfileLoaderComposite(remoteLoader: remoteLoader, localLoader: localLoader)
        
        let profileView = UserProfileUIComposer.userProfileComposedWith(loader: compositeLoader, viewModel: viewModel) {[coreDataStack] user in
            let userProvider = UsersCoreDataRepository(coreDataStack: coreDataStack)
            userProvider.createOrUpdate(user: user)
            userProvider.coreDataStack.saveContext()
        }
        navigationController.pushViewController(profileView, animated: true)
    }

}

