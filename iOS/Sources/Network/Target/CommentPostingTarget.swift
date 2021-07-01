//
//  CommentPostingTarget.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct CommentPostingTarget: Target {
    var routerVersion: TargetVersion { .movieAPI }
    var method: HTTPMethod { .post }
    var paths: [String] { ["comment"] }
    var parameter: [String: String]?
    var body: Data?
    
    init(body: Data?) {
        self.body = body
    }
}
