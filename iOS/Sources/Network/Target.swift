//
//  Target.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

protocol Target {
    var routerVersion: TargetVersion { get }
    var method: HTTPMethod { get }
    var paths: [String] { get }
    var parameter: [String: String]? { get }
    var body: Data? { get }
}
