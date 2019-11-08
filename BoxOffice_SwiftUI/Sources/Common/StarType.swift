//
//  StarType.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

enum StarType {
  case normal

  case half

  case full
}

extension StarType {
  var imageName: String {
    switch self {
    case .normal:
      return "ic_star_large"
    case .half:
      return "ic_star_large_half"
    case .full:
      return "ic_star_large_full"
    }
  }
}
