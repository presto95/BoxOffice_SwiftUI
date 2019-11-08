//
//  MovieResponse.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

struct MovieResponse: Decodable, Identifiable {
  let userRating: Double

  let actor: String

  let director: String

  let date: String

  let grade: Int

  let reservationRate: Double

  let image: String

  let duration: Int

  let id: String

  let reservationGrade: Int

  let title: String

  let synopsis: String

  let audience: Int

  let genre: String

  private enum CodingKeys: String, CodingKey {
    case userRating = "user_rating"

    case actor

    case director

    case date

    case grade

    case reservationRate = "reservation_rate"

    case image

    case duration

    case id

    case reservationGrade = "reservation_grade"

    case title

    case synopsis

    case audience

    case genre
  }
}

extension MovieResponse {
  static let dummy = MovieResponse(userRating: 0,
                                   actor: "",
                                   director: "",
                                   date: "",
                                   grade: 0,
                                   reservationRate: 0,
                                   image: "",
                                   duration: 0,
                                   id: "",
                                   reservationGrade: 0,
                                   title: "",
                                   synopsis: "",
                                   audience: 0,
                                   genre: "")
}
