//
//  SortMethod.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

enum SortMethod: Int {
    case reservation
    case curation
    case date
}

extension SortMethod: CustomStringConvertible {
    var description: String {
        switch self {
        case .reservation:
            return "예매율순"
        case .curation:
            return "큐레이션"
        case .date:
            return "개봉일순"
        }
    }
}
