//
//  UsersCoreDataRepositoryTests.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import XCTest
import GithubList

class UsersCoreDataRepositoryTests: XCTestCase{
    
    func test_get_deliversEmptyOnEmptyCache() {
        let (sut, _) = makeSUT()

        let users = sut.getUsers()
        XCTAssertNil(users, "Expected no users on empty cache")
    }
    
    func test_saveUser_deliversUserCorrectly() {
        let (sut, _) = makeSUT()

        let user = makeUser()
        sut.save([user])
        
        let receivedUser = sut.getUsers()?.first
        
        XCTAssertNotNil(receivedUser, "Report should not be nil")
        XCTAssertEqual(receivedUser!.notes, user.notes)
        XCTAssertEqual(receivedUser!.loginName, user.loginName)
    }
    
    func test_updateUser_deliversUserCorrectly() {
        let (sut, _) = makeSUT()

        let user = makeUser(notes: "a note")
        sut.save([user])
        
        let savedUser = sut.getUsers()?.first
        savedUser?.notes = "Updated notes"
        
        let receivedUser = sut.getUsers()?.first
        XCTAssertEqual(receivedUser!.notes, "a note", "Expected received user not updated before save")
        
        sut.save([savedUser!])
        let receivedUpdatedUser = sut.getUsers()?.first
        XCTAssertEqual(receivedUpdatedUser!.notes, "Updated notes", "Expected received user to be updated with new notes")
    }
    
    func test_backgroundContext_didSavedfterSavingUser() {
        let (sut, coreDataStack) = makeSUT()
        
        expectation(
          forNotification: .NSManagedObjectContextDidSave,
          object: coreDataStack.backgroundContext) { _ in
            return true
        }
        
        sut.save([makeUser()])
        
      waitForExpectations(timeout: 2.0) { error in
        XCTAssertNil(error, "Save did not occur")
      }
    }
    
    // MARK:  Helpers
    
    func makeSUT() -> (UsersRepository, CoreDataStack){
        let inMemoryStoreURL = URL(fileURLWithPath: "/dev/null")
        let coreDataStack = try! CoreDataStack(storeURL: inMemoryStoreURL)
        let sut = UsersCoreDataRepository(coreDataStack: coreDataStack)
        return (sut, coreDataStack)
    }
    
    func makeUser(notes: String = "test notes") -> User{
        let user = User()
        user.loginName = "testLogin"
        user.id = 10
        user.notes = notes
        return user
    }
    
}

