//
//  UserListViewModelTests.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import XCTest
import GithubList

class UserListViewModelTests: XCTestCase {
    
    func test_filterKey_filterModels(){
        let sut = makeSUT()
        sut.loadData()
        var filterKey: String?
        
//        let exp = expectation(description: "Expected filter to get called in onListLoad")
        
        sut.onListLoad = { users in
            if filterKey == nil{
                XCTAssertEqual(users.count, 3, "Expected to get 3 users when no filter")
            }
            else if filterKey == "another name"{
                XCTAssertEqual(users.count, 1, "Expected to get 1 user when filtered with key 'another name`")
            }
            else if filterKey == "other note"{
                XCTAssertEqual(users.count, 2, "Expected to get 2 user when filtered with key 'other note`")
            }
        }
        
        filterKey = "another name"
        sut.updateFilteredUsers(with: filterKey)
        filterKey = "other note"
        sut.updateFilteredUsers(with: filterKey)

//        wait(for: [exp], timeout: 1)
        
    }
    
    
    
    func makeSUT() -> UserListViewModel{
        let sut = UserListViewModel(service: UsersLoaderStub())
        return sut
    }
    
}
