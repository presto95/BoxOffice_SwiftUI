//
//  Log.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/17.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

enum Log {
  
  static func debug(_ message: Any,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
    #if DEBUG
    let fileName = file.split(separator: "/").last ?? ""
    let functionName = function.split(separator: "(").first ?? ""
    print("👻 [\(fileName)] \(functionName)(\(line)): \(message)")
    #endif
  }

  static func error(_ message: Any,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
    let fileName = file.split(separator: "/").last ?? ""
    let functionName = function.split(separator: "(").first ?? ""
    print("❌ [\(fileName)] \(functionName)(\(line)): \(message)")
  }

}
