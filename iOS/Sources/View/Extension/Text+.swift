//
//  Text+.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/30.
//  Copyright © 2020 presto. All rights reserved.
//

import SwiftUI

extension Text {
    func titleStyle() -> some View {
        return self
            .font(.title3)
            .fontWeight(.bold)
            .lineLimit(2)
    }
    
    func contentsStyle() -> some View {
        return self
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}
