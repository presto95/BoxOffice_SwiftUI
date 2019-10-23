//
//  DateFormatter+.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/18.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

extension DateFormatter {

  static func custom(_ format: String) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter
  }
}
