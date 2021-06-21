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
  var body: some Scene {
    WindowGroup {
      MovieMainView(viewModel: MovieMainViewModel(apiService: MovieAPIService()))
        .accentColor(.purple)
    }
  }
}
