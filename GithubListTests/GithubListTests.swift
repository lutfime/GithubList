//
//  GithubListTests.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 23/11/2022.
//

import XCTest
@testable import GithubList

final class GithubListTests: XCTestCase {
    var mockAPIClient: UserAndProfileLoader!
    var userListViewModel: UserListViewModel!
    var profileViewModel: ProfileViewModel!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIClient = MockAPIClient()
        userListViewModel = UserListViewModel(loader: mockAPIClient, imageLoader: {MockImageLoader()})
        profileViewModel = ProfileViewModel(loader: mockAPIClient)
    }

    func testFetchUsers() {
        userListViewModel!.loadData()
        
        let firstUser = userListViewModel.users.first!
        XCTAssertEqual(userListViewModel.users.count, 2)
        XCTAssertEqual(firstUser.id, 1)
        XCTAssertTrue(firstUser.profileURL.count > 0)
    }
    
    func testFetchUserProfile() {
        profileViewModel!.loadUserProfile(loginName: "mojombo")
        
        let user = profileViewModel!.user
        XCTAssertEqual(user!.followerCount, 23256)
    }

}

class MockImageLoader: ImageLoader{
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        completion(.success(UIImage()))
    }
    
    
}
