//
//  UsersLoaderCompositeTests.swift
//  GithubListTests
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import XCTest
import GithubList

class UsersLoaderCompositeTests: XCTestCase{
    
    func test_loadUsers_combineLocalAndRemoteUsers(){
        let sut = makeSUT()
        let exp = expectation(description: "Wait for result")
        sut.loadGithubUsers(startUserIndex: 2) { result in
            if let users = try? result.get(){
                XCTAssertEqual(users.count, 3, "Expected to get 3 users after local and remote users combined")
                XCTAssertEqual(users[0].id, 1, "Expected first user id 1")
                XCTAssertEqual(users[1].id, 2, "Expected first user id 1")
                XCTAssertEqual(users[2].id, 3, "Expected first user id 1")

            }else{
                XCTFail("Expected to get users successfully")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func makeSUT() -> UsersLoaderComposite{
        let localUsers = [makeUser(id: 1, loginName: "name 1"), makeUser(id: 2, loginName: "name 2"), makeUser(id: 3, loginName: "name 3")]
        let remoteUsers = [makeUser(id: 2, loginName: "name 2")]

        let sut = UsersLoaderComposite(localLoader: UsersLoaderStub(users: localUsers), remoteLoader: UsersLoaderStub(users: remoteUsers))
        return sut
    }
    
}
