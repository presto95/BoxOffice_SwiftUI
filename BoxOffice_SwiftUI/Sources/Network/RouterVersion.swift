//
//  RouterVersion.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

enum RouterVersion {

  case movieAPI
}

extension RouterVersion {

  var scheme: String { "https" }

  var host: String { "connect-boxoffice.run.goorm.io" }
}
