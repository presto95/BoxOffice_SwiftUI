//
//  MovieMainViewNavigationBarStyle.swift
//  BoxOffice
//
//  Created by Presto on 2021/07/11.
//  Copyright © 2021 presto. All rights reserved.
//

import SwiftUI

struct MovieMainViewNavigationBarStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationTitle(Text("BoxOffice"))
            .navigationBarTitleDisplayMode(.automatic)
    }
}

extension View {
    func movieMainViewNavigationBarStyle() -> some View {
        return self
            .modifier(MovieMainViewNavigationBarStyle())
    }
}
