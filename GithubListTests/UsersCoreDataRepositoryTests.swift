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
        let sut = makeSUT()
        
        let users = sut.getUsers()
        XCTAssertNil(users, "Expected no users on empty cache")
    }
    
    func makeSUT() -> UsersRepository{
        let inMemoryStoreURL = URL(fileURLWithPath: "/dev/null")
        let coreDataStack = try! CoreDataStack(storeURL: inMemoryStoreURL)
        let sut = UsersCoreDataRepository(coreDataStack: coreDataStack)
        return sut
    }
    
}

