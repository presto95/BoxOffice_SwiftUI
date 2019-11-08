//
//  MovieTarget.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct MovieTarget: TargetType {
  var routerVersion: TargetVersion { .movieAPI }

  var method: HTTPMethod { .get }

  var paths: [String] { ["movie"] }

  var parameter: [String: String]?

  var body: Data?

  init(parameter: [String: String]?) {
    self.parameter = parameter
  }
}
