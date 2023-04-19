//
//  UserListSnapshotTests.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import XCTest
import GithubList

class UserListSnapshotTests: XCTestCase {

    func test_listUser_withNotes() {
        let sut = makeSUT(loader: UsersLoaderStub(users: makeUsersWithNotes()))
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LIST_USER_VC_notes")
    }
    
    func test_listUser_withoutNotes() {
        let sut = makeSUT(loader: UsersLoaderStub(users: makeUsersWithoutNotes()))
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LIST_USER_VC")
    }

    // MARK: - Helpers

    private func makeSUT(loader: UsersLoaderStub = UsersLoaderStub()) -> UserListViewController {
        let bundle = Bundle(for: UserListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateViewController(identifier: "userList") { coder in
            let viewModel = UserListViewModel(loader: loader, imageLoader: {RedImageLoader()})
            return UserListViewController(coder: coder, viewModel: viewModel)
        } as! UserListViewController
        
        controller.loadViewIfNeeded()
        controller.collectionView.showsVerticalScrollIndicator = false
        controller.collectionView.showsHorizontalScrollIndicator = false
        
        controller.viewModel.loadData()
        
        RunLoop.current.run(until: Date())
        
        return controller
    }

    func makeUsersWithoutNotes() -> [User]{
        let user = User()
        user.loginName = "a name"
        user.avatarURL = "https://aURL.com"
        
        let user2 = User()
        user2.loginName = "other name"
        user2.avatarURL = "https://otherURL.com"
        
        let user3 = User()
        user3.loginName = "another name"
        user3.avatarURL = "https://anotherURL.com"
        
        let user4 = User()
        user4.loginName = "another another name"
        user4.avatarURL = "https://anotherAnotherURL.com"
        return [user, user2, user3, user4]
    }
    
    func makeUsersWithNotes() ->  [User]{
        UsersLoaderStub.defaultUsers
    }
}

private class RedImageLoader: ImageLoader{
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        completion(.success(UIImage.make(withColor: .red)))
    }
}
