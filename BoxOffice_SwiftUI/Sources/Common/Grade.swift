//
//  Grade.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

enum Grade: Int {

  case allAges = 0

  case twelve = 12

  case fifteen = 15

  case nineteen = 19
}

extension Grade {

  var imageName: String {
    switch self {
    case .allAges:
      return "ic_allages"
    case .twelve:
      return "ic_12"
    case .fifteen:
      return "ic_15"
    case .nineteen:
      return "ic_19"
    }
  }
}
