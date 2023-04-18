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
            let viewModel = UserListViewModel(loader: loader)
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
        user.avatarURL = "a url"
        
        let user2 = User()
        user2.loginName = "other name"
        user2.avatarURL = "other url"
        
        let user3 = User()
        user3.loginName = "another name"
        user3.avatarURL = "another url"
        return [user, user2, user3]
    }
    
    func makeUsersWithNotes() ->  [User]{
        UsersLoaderStub.defaultUsers
    }
    
}
