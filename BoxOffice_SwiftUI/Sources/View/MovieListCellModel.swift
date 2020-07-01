//
//  MovieListCellModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieListCellModel: ObservableObject, NetworkImageFetchable {
  private var cancellables = Set<AnyCancellable>()
  
  init(movie: MoviesResponseModel.Movie) {
    let movieSharedPublisher = movieSubject
      .compactMap { $0 }
      .share()

    movieSharedPublisher
      .map(\.grade)
      .compactMap(Grade.init)
      .map(\.imageName)
      .assign(to: \.gradeImageName, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map(\.title)
      .assign(to: \.title, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map(\.userRating)
      .map { "평점 : \($0)" }
      .assign(to: \.rating, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map(\.reservationGrade)
      .map { "예매순위 : \($0)" }
      .assign(to: \.reservationGrade, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map(\.reservationRate)
      .map { "예매율 : \($0)%" }
      .assign(to: \.reservationRate, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map(\.date)
      .map { "개봉일 : \($0)" }
      .assign(to: \.date, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map(\.thumb)
      .flatMap(networkImageData(from:))
      .assign(to: \.posterImageData, on: self)
      .store(in: &cancellables)

    movieSubject.send(movie)
  }

  // MARK: - Outputs
  
  @Published var posterImageData: Data?
  @Published var gradeImageName: String = ""
  @Published var title: String = ""
  @Published var rating: String = ""
  @Published var reservationGrade: String = ""
  @Published var reservationRate: String = ""
  @Published var date: String = ""
  
  // MARK: - Subjects

  private let movieSubject = CurrentValueSubject<MoviesResponseModel.Movie?, Never>(nil)
}
