//
//  MovieResponse.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

struct MovieDetailResponseModel: Decodable, Identifiable {
  let userRating: Double
  let actor: String
  let director: String
  let date: String
  let grade: Int
  let reservationRate: Double
  let imageURLString: String
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
    case imageURLString = "image"
    case duration
    case id
    case reservationGrade = "reservation_grade"
    case title
    case synopsis
    case audience
    case genre
  }
}

extension MovieDetailResponseModel {
  static let dummy = MovieDetailResponseModel(userRating: 9.5,
                                   actor: "Presto",
                                   director: "Presto",
                                   date: "2020-02-02",
                                   grade: 7,
                                   reservationRate: 32.2,
                                   imageURLString: "",
                                   duration: 120,
                                   id: "1",
                                   reservationGrade: 1,
                                   title: "영화",
                                   synopsis: "줄거리",
                                   audience: 172948,
                                   genre: "장르")
}
