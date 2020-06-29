//
//  Comment.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct Comment: Encodable {
  let rating: Int
  let writer: String
  let movieID: String
  let contents: String

  private enum CodingKeys: String, CodingKey {
    case rating
    case writer
    case movieID = "movie_id"
    case contents
  }
}
