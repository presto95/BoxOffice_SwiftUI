//
//  MovieGridCellModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2020/06/29.
//  Copyright © 2020 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieGridCellModel: ObservableObject, NetworkImageFetchable {
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
      .assign(to: \.primaryText, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map { "\($0.reservationGrade)위(\($0.userRating)) / \($0.reservationRate)%" }
      .assign(to: \.secondaryText, on: self)
      .store(in: &cancellables)

    movieSharedPublisher
      .map(\.date)
      .assign(to: \.tertiaryText, on: self)
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
  @Published var primaryText: String = ""
  @Published var secondaryText: String = ""
  @Published var tertiaryText: String = ""

  // MARK: - Subjects

  private let movieSubject = CurrentValueSubject<MoviesResponseModel.Movie?, Never>(nil)
}
