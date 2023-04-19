//
//  InternetConnectionUpdater.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import Foundation

enum InternetConnectionState{
    case connected
    case notConnected
}

protocol InternetConnectionUpdater{
    func internetConnectionUpdated(_ state: InternetConnectionState)
}
