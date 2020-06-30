//
//  CommentsViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class CommentsViewModel: ObservableObject {
  private let apiService: MovieAPIServiceProtocol

  private var cancellables = Set<AnyCancellable>()

  init(movie: MovieDetailResponseModel, apiService: MovieAPIServiceProtocol = MovieAPIService()) {
    self.movie = movie
    self.apiService = apiService

    ratingSubject
      .compactMap { $0 }
      .assign(to: \.rating, on: self)
      .store(in: &cancellables)
  }

  // MARK: - Inputs

  func setRating(_ rating: Double) {
    ratingSubject.send(rating)
  }

  func requestCommentPosting() {
    let comment = Comment(rating: Int(rating),
                          writer: nickname,
                          movieID: movie.id,
                          contents: comments)
    apiService.requestCommentPosting(comment: comment)
      .receive(on: DispatchQueue.main)
      .map { _ in true }
      .replaceError(with: false)
      .assign(to: \.isPostingFinished, on: self)
      .store(in: &cancellables)
  }

  // MARK: - Outputs

  @Published var movie: MovieDetailResponseModel = .dummy
  @Published var rating = 0.0
  @Published var nickname = ""
  @Published var comments = ""
  @Published var isPostingFinished = false

  var movieTitle: String { movie.title }

  var movieGradeImageName: String { (Grade(rawValue: movie.grade) ?? .allAges).imageName }
  
  var movieRatingString: String { "\(Int(rating))" }

  // MARK: - Subjects

  private let ratingSubject = CurrentValueSubject<Double?, Never>(nil)
}
