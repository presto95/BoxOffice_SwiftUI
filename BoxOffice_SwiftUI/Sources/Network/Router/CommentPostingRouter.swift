//
//  CommentPostingRouter.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct CommentPostingRouter: RouterType {

  var routerVersion: RouterVersion { .movieAPI }

  var method: HTTPMethod { .post }

  var path: String { "/comment" }

  var parameter: [URLQueryItem]

  var body: Data?

  init(parameter: [String : String]?, body: Data?) {
    self.parameter = parameter?.map { URLQueryItem(name: $0.key, value: $0.value) } ?? []
    self.body = body
  }
}
