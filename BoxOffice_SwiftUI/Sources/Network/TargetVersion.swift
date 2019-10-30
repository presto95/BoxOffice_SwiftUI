//
//  TargetVersion.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

enum TargetVersion {

  case movieAPI
}

extension TargetVersion {

  var scheme: String {
    switch self {
    case .movieAPI:
      return "https"
    }
  }

  var host: String {
    switch self {
    case .movieAPI:
      return "connect-boxoffice.run.goorm.io"
    }
  }
}
