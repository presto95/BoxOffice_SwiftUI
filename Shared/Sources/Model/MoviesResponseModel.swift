//
//  MoviesResponse.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct MoviesResponseModel: Decodable, Identifiable {
  struct Movie: Decodable, Identifiable, Equatable {
    let userRating: Double
    let grade: Int
    let date: String
    let reservationRate: Double
    let id: String
    let reservationGrade: Int
    let title: String
    let thumb: String

    private enum CodingKeys: String, CodingKey {
      case userRating = "user_rating"
      case grade
      case date
      case reservationRate = "reservation_rate"
      case id
      case reservationGrade = "reservation_grade"
      case title
      case thumb
    }
  }

  let id = UUID()
  let movies: [Movie]
  let sortMethod: Int

  private enum CodingKeys: String, CodingKey {
    case movies
    case sortMethod = "order_type"
  }
}

extension MoviesResponseModel.Movie {
  static let dummy = MoviesResponseModel.Movie(userRating: 9.7,
                                          grade: 12,
                                          date: "2020-06-29",
                                          reservationRate: 79.6,
                                          id: "1",
                                          reservationGrade: 1,
                                          title: "신과 함께-죄와벌",
                                          thumb: "")
}

extension MoviesResponseModel {
  static let dummy = MoviesResponseModel(movies: [.dummy], sortMethod: 0)
}
