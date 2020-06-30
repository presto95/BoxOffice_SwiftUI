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
  private let movie: MoviesResponseModel.Movie
  private var cancellables = Set<AnyCancellable>()
  
  init(movie: MoviesResponseModel.Movie) {
    self.movie = movie
    requestPosterImage(from: movie.thumb)
    
    posterImageDataSubject
      .assign(to: \.posterImageData, on: self)
      .store(in: &cancellables)
  }
  
  // MARK: - Inputs
  
  func requestPosterImage(from urlString: String) {
      networkImageData(from: urlString)
        .sink(receiveCompletion: { [weak self] completion in
          if case .failure = completion {
            self?.posterImageDataSubject.send(nil)
          }
        }, receiveValue: { [weak self] data in
          self?.posterImageDataSubject.send(data)
        })
        .store(in: &cancellables)
  }
  
  // MARK: - Outputs
  
  @Published var posterImageData: Data?
  
  var gradeImageName: String { Grade(rawValue: movie.grade)?.imageName ?? "" }

  var title: String { movie.title }

  var rating: String { "평점 : \(movie.userRating)" }

  var reservationGrade: String { "예매순위 : \(movie.reservationGrade)" }

  var reservationRate: String { "예매율 : \(movie.reservationRate)%" }

  var date: String { "개봉일 : \(movie.date)" }
  
  // MARK: - Subjects
  
  private let posterImageDataSubject = CurrentValueSubject<Data?, Never>(nil)
  private let movieSubject = CurrentValueSubject<MoviesResponseModel.Movie?, Never>(nil)
}
