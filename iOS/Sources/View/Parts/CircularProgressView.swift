//
//  CircularProgressView.swift
//  BoxOffice
//
//  Created by Presto on 2021/07/11.
//  Copyright © 2021 presto. All rights reserved.
//

import SwiftUI

struct CircularProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
}
