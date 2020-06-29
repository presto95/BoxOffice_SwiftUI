//
//  MovieDetailViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieDetailViewModel: ObservableObject, NetworkImageFetchable {
  private enum RequestType {
    case movie
    case comments
  }

  private let apiService: MovieAPIServiceProtocol
  private let movieID: String

  private var cancellables = Set<AnyCancellable>()

  init(movieID: String, apiService: MovieAPIServiceProtocol = MovieAPIService()) {
    self.movieID = movieID
    self.apiService = apiService

    isPresentedSubject
      .compactMap { $0 }
      .sink(receiveValue: { [self] _ in
        self.requestData()
      })
      .store(in: &cancellables)

    isLoadingSubject
      .compactMap { $0 }
      .map { $0 || $1 }
      .assign(to: \.isLoading, on: self)
      .store(in: &cancellables)

    showsCommentPostingSubject
      .compactMap { $0 }
      .assign(to: \.showsCommentPosting, on: self)
      .store(in: &cancellables)

    movieResponseSubject
      .compactMap { $0 }
      .tryMap { try $0.get() }
      .sink(receiveCompletion: { [self] completion in
        if case .failure = completion {
          self.movieErrors.append(.movieDetailRequestFailed)
        }
      }, receiveValue: { [self] movieResponse in
        self.movie = movieResponse
        self.networkImageData(from: movieResponse.imageURLString)
          .sink(receiveCompletion: { [self] completion in
            if case .failure = completion {
              self.posterImageDataSubject.send(nil)
            }
          }, receiveValue: { [self] data in
            self.posterImageDataSubject.send(data)
          })
          .store(in: &cancellables)
      })
      .store(in: &cancellables)

    commentsSubject
      .compactMap { $0 }
      .tryMap { try $0.get() }
      .sink(receiveCompletion: { [self] completion in
        if case .failure = completion {
          self.movieErrors.append(.commentsRequestFailed)
        }
      }, receiveValue: { [self] comments in
        self.comments = comments
      })
      .store(in: &cancellables)

    posterImageDataSubject
      .assign(to: \.posterImageData, on: self)
      .store(in: &cancellables)
  }

  // MARK: - Inputs

  func setPresented() {
    isPresentedSubject.send(Void())
  }

  func setShowsCommentPosting() {
    showsCommentPostingSubject.send(true)
  }

  func retryMovieCommentsRequest() {
    requestData()
  }

  // MARK: - Outputs

  @Published var isLoading = false
  @Published var showsCommentPosting = false
  @Published var movie: MovieDetailResponseModel = .dummy
  @Published var comments: [CommentsResponseModel.Comment] = []
  @Published var posterImageData: Data?
  @Published var movieErrors: [MovieError] = []

  var movieTitle: String { movie.title }
  var movieGradeImageName: String { (Grade(rawValue: movie.grade) ?? .allAges).imageName }
  var movieDate: String { "\(movie.date) 개봉" }
  var movieGenreAndDuration: String { "\(movie.genre) / \(movie.duration)분" }
  var movieReservationMetric: String {
    "\(movie.reservationGrade)위 \(String(format: "%.1f%%", movie.reservationRate))"
  }
  var movieUserRatingString: String { String(format: "%.2f", movie.userRating) }
  var movieUserRating: Double { movie.userRating }
  var movieAudience: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: movie.audience as NSNumber) ?? "?"
  }
  var movieSynopsis: String { movie.synopsis }
  var movieDirector: String { movie.director }
  var movieActor: String { movie.actor }

  func commentsWriter(at index: Int) -> String { comments[index].writer }
  func commentsScore(at index: Int) -> Double { comments[index].rating }
  func commentsContents(at index: Int) -> String { comments[index].contents }
  func commentsDateString(at index: Int) -> String {
    comments[index].dateString(formatter: .custom("yyyy-MM-dd HH:mm:ss"))
  }

  // MARK: - Subjects

  private let isPresentedSubject = CurrentValueSubject<Void?, Never>(nil)
  private let isLoadingSubject = CurrentValueSubject<(Bool, Bool)?, Never>(nil)
  private let showsCommentPostingSubject = CurrentValueSubject<Bool?, Never>(nil)
  private let movieResponseSubject = CurrentValueSubject<Result<MovieDetailResponseModel, Error>?, Never>(nil)
  private let commentsSubject = CurrentValueSubject<Result<[CommentsResponseModel.Comment], Error>?, Never>(nil)
  private let posterImageDataSubject = CurrentValueSubject<Data?, Never>(nil)
}

extension MovieDetailViewModel {
  private func requestData() {
    movieErrors = []
    apiService.requestMovieDetail(movieID: movieID)
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveSubscription: { [self] _ in
        self.changeLoading(true, to: .movie)
      })
      .sink(receiveCompletion: { [self] completion in
        if case let .failure(error) = completion {
          self.movieResponseSubject.send(.failure(error))
        }
        self.changeLoading(false, to: .movie)
      }, receiveValue: { [self] movieResponse in
        self.movieResponseSubject.send(.success(movieResponse))
      })
      .store(in: &cancellables)

    apiService.requestComments(movieID: movieID)
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveSubscription: { [self] _ in
        self.changeLoading(true, to: .comments)
      })
      .sink(receiveCompletion: { [self] completion in
        if case let .failure(error) = completion {
          self.commentsSubject.send(.failure(error))
        }
        self.changeLoading(false, to: .comments)
      }, receiveValue: { [self] commentsResponse in
        self.commentsSubject.send(.success(commentsResponse.comments))
      })
      .store(in: &cancellables)
  }

  private func changeLoading(_ value: Bool, to type: MovieDetailViewModel.RequestType) {
    var currentLoading = isLoadingSubject.value ?? (false, false)
    switch type {
    case .movie:
      currentLoading.0 = value
    case .comments:
      currentLoading.1 = value
    }
    isLoadingSubject.send(currentLoading)
  }
}
