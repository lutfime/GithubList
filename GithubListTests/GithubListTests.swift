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
    
    var dataProvider: UsersProvider!
    var coreDataStack: CoreDataStack!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIClient = MockAPIClient()
        userListViewModel = UserListViewModel(loader: mockAPIClient)
        profileViewModel = ProfileViewModel(service: mockAPIClient)
        
        coreDataStack = TestCoreDataStack()
        dataProvider = UsersProvider(coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataProvider = nil
        coreDataStack = nil
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
    
    func testAddUser() {
        let user = User()
        user.loginName = "testLogin"
        user.id = 10
        user.notes = "test notes"
        let userManagedObject = dataProvider.add(user)
        
        XCTAssertNotNil(userManagedObject, "Report should not be nil")
        XCTAssertTrue(userManagedObject.notes == "test notes")
        XCTAssertTrue(userManagedObject.loginName == "testLogin")
    }
    
    func testRootContextIsSavedAfterAddingUser() {
        expectation(
          forNotification: .NSManagedObjectContextDidSave,
          object: coreDataStack.backgroundContext) { _ in
            return true
        }
        
        let user = User()
        user.loginName = "testLogin"
        user.id = 10
        user.notes = "test notes"
        dataProvider.add(user)

      waitForExpectations(timeout: 2.0) { error in
        XCTAssertNil(error, "Save did not occur")
      }
    }
    
    func testGetUsers() {
        let user = User()
        user.loginName = "testLogin"
        user.id = 10
        user.notes = "test notes"
        dataProvider.add(user)
        
        let getUsers = dataProvider.getUsers()
        XCTAssertNotNil(getUsers)
        XCTAssertTrue(getUsers?.count == 1)
        XCTAssertTrue(user.id == (getUsers?.first!.userId)!)
    }
    
    func testUpdateUser() {
        let user = User()
        user.loginName = "testLogin"
        user.id = 10
        user.notes = "test notes"
        let userManagedObject = dataProvider.add(user)
        userManagedObject.notes = "updated notes"
        dataProvider.update(userManagedObject)
        
        XCTAssertTrue(userManagedObject.notes == "updated notes")
    }
}
