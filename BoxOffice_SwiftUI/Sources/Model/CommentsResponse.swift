//
//  CommentsResponse.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct CommentsResponse: Decodable, Identifiable {
  struct Comment: Decodable, Identifiable {
    let movieID: String

    let contents: String

    let timestamp: Double

    let id: String

    let writer: String

    let rating: Double

    private enum CodingKeys: String, CodingKey {
      case movieID = "movie_id"

      case contents

      case timestamp

      case id

      case writer

      case rating
    }
  }

  let id = UUID()

  let comments: [Comment]

  let movieID: String

  private enum CodingKeys: String, CodingKey {
    case comments

    case movieID = "movie_id"
  }
}

extension CommentsResponse.Comment {
  static let dummy = CommentsResponse.Comment(movieID: "",
                                              contents: "",
                                              timestamp: 0,
                                              id: "",
                                              writer: "",
                                              rating: 0)

  func dateString(formatter: DateFormatter) -> String {
    formatter.string(from: Date(timeIntervalSince1970: timestamp))
  }
}
