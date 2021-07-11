//
//  BoxOfficeApp.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import SwiftUI

@main
struct BoxOfficeApp: App {
    init() {
        DIContainer.shared.register(NetworkManager())
        DIContainer.shared.register(APIService())
    }

    var body: some Scene {
        WindowGroup {
            MovieMainView(viewModel: MovieMainViewModel())
                .accentColor(.purple)
        }
    }
}
