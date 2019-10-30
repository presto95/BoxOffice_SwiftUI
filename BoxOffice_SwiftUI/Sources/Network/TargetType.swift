//
//  TargetType.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

protocol TargetType {

  var routerVersion: TargetVersion { get }

  var method: HTTPMethod { get }

  var paths: [String] { get }

  var parameter: [URLQueryItem] { get }

  var body: Data? { get }
}
