//
//  RouterType.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

protocol RouterType {

  var routerVersion: RouterVersion { get }

  var method: HTTPMethod { get }

  var path: String { get }

  var parameter: [URLQueryItem] { get }

  var body: Data? { get }

  init(parameter: [String: String]?, body: Data?)
}
