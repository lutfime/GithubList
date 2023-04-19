//
//  ImageLoader.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 19/04/2023.
//

import UIKit

public protocol ImageLoader{
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}
