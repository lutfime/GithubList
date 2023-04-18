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
        var filterDone = false
        
        sut.onListLoad = { users in
            if !filterDone{
                XCTAssertEqual(users.count, 3, "Expected to get 3 users when no filter")
            }else{
                XCTAssertEqual(users.count, 1, "Expected to get 1 user when filtered with key 'other name`")
            }
        }
        
        filterDone = true
        sut.updateFilteredUsers(with: "other name")
        
    }
    
    
    
    func makeSUT() -> UserListViewModel{
        let sut = UserListViewModel(service: UsersLoaderStub())
        return sut
    }
    
}
