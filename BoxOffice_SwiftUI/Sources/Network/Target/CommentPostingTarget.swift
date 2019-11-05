//
//  CommentPostingTarget.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct CommentPostingTarget: TargetType {

  var routerVersion: TargetVersion { .movieAPI }

  var method: HTTPMethod { .post }

  var paths: [String] { ["comment"] }

  var parameter: [String: String]?

  var body: Data?

  init(parameter: [String : String]?, body: Data?) {
    self.parameter = parameter
    self.body = body
  }
}
