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
        .sink(receiveCompletion: { [self] completion in
          if case .failure = completion {
            self.posterImageDataSubject.send(nil)
          }
        }, receiveValue: { [self] data in
          self.posterImageDataSubject.send(data)
        })
        .store(in: &cancellables)
  }
  
  // MARK: - Outputs
  
  @Published var posterImageData: Data?
  var gradeImageName: String { Grade(rawValue: movie.grade)?.imageName ?? "" }
  var primaryText: String { movie.title }
  var secondaryText: String {
    """
    평점 : \(movie.userRating) 예매순위 : \(movie.reservationGrade) 예매율 : \(movie.reservationRate)%
    """
  }
  var tertiaryText: String { "개봉일 : \(movie.date)" }
  
  // MARK: - Subjects
  
  private let posterImageDataSubject = CurrentValueSubject<Data?, Never>(nil)
  private let movieSubject = CurrentValueSubject<MoviesResponseModel.Movie?, Never>(nil)
}
