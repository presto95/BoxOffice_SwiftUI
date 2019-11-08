//
//  MoviesResponse.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct MoviesResponse: Decodable, Identifiable {
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

  let orderType: Int

  private enum CodingKeys: String, CodingKey {
    case movies

    case orderType = "order_type"
  }
}

extension MoviesResponse.Movie {
  static let dummy = MoviesResponse.Movie(userRating: 0,
                                          grade: 0,
                                          date: "",
                                          reservationRate: 0,
                                          id: "",
                                          reservationGrade: 0,
                                          title: "",
                                          thumb: "")
}

extension MoviesResponse {
  static let dummy = MoviesResponse(movies: [.dummy], orderType: 0)
}
