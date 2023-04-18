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
        viewModel: UserCellViewModel
    ) -> UIHostingController<UserProfileView> {
        let model = ProfileViewModel(service: loader)
        var profileView = UserProfileView(viewModel: model)
        profileView.loginName = viewModel.loginName
        profileView.avatarURL = viewModel.avatarURL

        let vc = UIHostingController(rootView: profileView)
        return vc
    }
}
