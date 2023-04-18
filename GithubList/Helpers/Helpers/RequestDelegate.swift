//
//  RequestDelegate.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit

enum ViewState {
    case idle
    case loading
    case success
    case error(Error)
    
}

protocol RequestDelegate: AnyObject {
    func didUpdate(with state: ViewState)
}
