//
//  UserListSnapshotTests.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import XCTest
import GithubList

class UserListSnapshotTests: XCTestCase {

    func test_ListUser() {
        let sut = makeSUT()
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LIST_USER_VC_normal")
    }

    // MARK: - Helpers

    private func makeSUT() -> UserListViewController {
        let bundle = Bundle(for: UserListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let controller = storyboard.instantiateViewController(identifier: "userList") { coder in
            let viewModel = UserListViewModel(service: MockAPIClientProtocol())
            return UserListViewController(coder: coder, viewModel: viewModel)
        } as! UserListViewController
        
        controller.loadViewIfNeeded()
        controller.collectionView.showsVerticalScrollIndicator = false
        controller.collectionView.showsHorizontalScrollIndicator = false
        
        controller.viewModel.loadData()
        
        RunLoop.current.run(until: Date())
        
        return controller
    }

}

private class MockAPIClientProtocol: UserAndProfileLoader{
    public func loadGithubUsers(startUserIndex: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        let user = User()
        user.loginName = "a name"
        user.avatarURL = "a url"
        
        let user2 = User()
        user2.loginName = "other name"
        user2.avatarURL = "other url"
        
        let user3 = User()
        user3.loginName = "another name"
        user3.avatarURL = "another url"
        
        completion(.success([user, user2, user3]))
    }
    
    public func loadUserProfile(loginName: String, completion: @escaping (Result<User, Error>) -> Void) {
        //Do nothing, not used in this test
    }
}
