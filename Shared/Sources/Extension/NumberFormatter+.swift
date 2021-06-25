//
//  NumberFormatter+.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/30.
//  Copyright © 2020 presto. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
