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
    
    let httpClient = URLSessionHTTPClient()
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
    
    private lazy var reachability: Reachability = {
        let reachability = try! Reachability()
        try! reachability.startNotifier()
        return reachability
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let localLoader = LocalLoader(usersRepository: usersRepository)
        let remoteLoader = APILoader(client: httpClient)
        let compositeLoader = UsersLoaderComposite(localLoader: localLoader, remoteLoader: remoteLoader).cachingUserListTo(coreDataStack)
        
        let userListVC = UserListUIComposer.userListComposedWith(
            loader: compositeLoader,
            imageLoader: makeImageLoader,
            selection: showUserProfile,
            internetConnectionUpdater: {[weak self] internetUpdater in
            self?.reachability.whenReachable = { reachability in
                internetUpdater.internetConnectionUpdated(.connected)
            }
            self?.reachability.whenUnreachable = { _ in
                internetUpdater.internetConnectionUpdated(.notConnected)
            }
        })

        navigationController.viewControllers = [userListVC]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showUserProfile(_ viewModel: UserCellViewModel){
        let localLoader = LocalLoader(usersRepository: usersRepository)
        let remoteLoader = APILoader(client: httpClient).cachingUserProfileTo(coreDataStack)
        let compositeLoader = UserProfileLoaderComposite(remoteLoader: remoteLoader, localLoader: localLoader)
        
        let profileView = UserProfileUIComposer.userProfileComposedWith(
            loader: compositeLoader,
            imageLoader: makeImageLoader,
            viewModel: viewModel) {[coreDataStack] user in
            let userProvider = UsersCoreDataRepository(coreDataStack: coreDataStack)
            userProvider.save([user])
        }
        navigationController.pushViewController(profileView, animated: true)
    }
    
    // MARK: Helpers
    
    func makeImageLoader() -> ImageLoader{
        let localImageLoader = LocalImageLoader()
        let remoteImageLoader = RemoteImageLoader(client: httpClient)
        let loader = localImageLoader
            .fallbackTo(remoteImageLoader
                .cachingTo(localImageLoader))
        
        return MainQueueDispatchDecorator(decoratee: loader)
    }
}

