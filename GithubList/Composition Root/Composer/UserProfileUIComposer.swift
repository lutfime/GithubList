//
//  UserProfileUIComposer.swift
//  GithubList
//
//  Created by Wan Ahmad Lutfi on 18/04/2023.
//

import SwiftUI

class UserProfileUIComposer{
    public static func userProfileComposedWith(
        loader: UserProfileLoader,
        imageLoader: @escaping () -> ImageLoader,
        viewModel: UserCellViewModel,
        saveUser: @escaping (User) -> ()
    ) -> UIHostingController<UserProfileView> {
        let model = ProfileViewModel(loader: MainQueueDispatchDecorator(decoratee: loader))
        var profileView = UserProfileView(viewModel: model, imageLoader: imageLoader)
        profileView.loginName = viewModel.loginName
        profileView.avatarURL = viewModel.avatarURL
        profileView.viewModel.onUserNeedSave = saveUser
        let vc = UIHostingController(rootView: profileView)
        return vc
    }
}
