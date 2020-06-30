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
      .sink(receiveValue: { [weak self] _ in
        self?.requestData()
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

    let movieResponseSharedPublisher = movieResponseSubject
      .compactMap { $0 }
      .tryMap { try $0.get() }
      .share()

    movieResponseSharedPublisher
      .sink(receiveCompletion: { [weak self] completion in
        self?.movieErrors.append(.movieDetailRequestFailed)
      }, receiveValue: { [weak self] movieResponse in
        self?.movie = movieResponse
      })
      .store(in: &cancellables)

    movieResponseSharedPublisher
      .flatMap { [weak self] response -> AnyPublisher<Data, Error> in
        guard let self = self else { return Empty<Data, Error>().eraseToAnyPublisher() }
        return self.networkImageData(from: response.imageURLString)
      }
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure = completion {
          self?.posterImageDataSubject.send(nil)
        }
      }, receiveValue: { [weak self] data in
        self?.posterImageDataSubject.send(data)
      })
      .store(in: &cancellables)

    commentsSubject
      .compactMap { $0 }
      .tryMap { try $0.get() }
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure = completion {
          self?.movieErrors.append(.commentsRequestFailed)
        }
      }, receiveValue: { [weak self] comments in
        self?.comments = comments
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

  func requestData() {
    changeLoading(true, to: .movie)
    changeLoading(true, to: .comments)

    movieErrors = []

    apiService.requestMovieDetail(movieID: movieID)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        if case let .failure(error) = completion {
          self?.movieResponseSubject.send(.failure(error))
        }
        self?.changeLoading(false, to: .movie)
      }, receiveValue: { [weak self] movieResponse in
        self?.movieResponseSubject.send(.success(movieResponse))
      })
      .store(in: &cancellables)

    apiService.requestComments(movieID: movieID)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        if case let .failure(error) = completion {
          self?.commentsSubject.send(.failure(error))
        }
        self?.changeLoading(false, to: .comments)
      }, receiveValue: { [weak self] commentsResponse in
        self?.commentsSubject.send(.success(commentsResponse.comments))
      })
      .store(in: &cancellables)
  }

  // MARK: - Outputs

  @Published var isLoading = false
  @Published var showsCommentPosting = false
  @Published var movie: MovieDetailResponseModel = .dummy
  @Published var comments: [CommentsResponseModel.Comment] = []
  @Published var posterImageData: Data?
  @Published var movieErrors: [MovieError] = []

  var title: String { movie.title }

  var gradeImageName: String { (Grade(rawValue: movie.grade) ?? .allAges).imageName }

  var date: String { "\(movie.date) 개봉" }

  var genreAndDuration: String { "\(movie.genre) / \(movie.duration)분" }

  var reservationMetric: String {
    "\(movie.reservationGrade)위 \(String(format: "%.1f%%", movie.reservationRate))"
  }

  var userRatingDescription: String { String(format: "%.2f", movie.userRating) }

  var userRating: Double { movie.userRating }

  var audience: String {
    return NumberFormatter.decimal.string(from: movie.audience as NSNumber) ?? "?"
  }

  var synopsis: String { movie.synopsis }

  var director: String { movie.director }

  var actor: String { movie.actor }

  // MARK: - Subjects

  private let isPresentedSubject = CurrentValueSubject<Void?, Never>(nil)
  private let isLoadingSubject = CurrentValueSubject<(Bool, Bool)?, Never>(nil)
  private let showsCommentPostingSubject = CurrentValueSubject<Bool?, Never>(nil)
  private let movieResponseSubject = CurrentValueSubject<Result<MovieDetailResponseModel, Error>?, Never>(nil)
  private let commentsSubject = CurrentValueSubject<Result<[CommentsResponseModel.Comment], Error>?, Never>(nil)
  private let posterImageDataSubject = CurrentValueSubject<Data?, Never>(nil)
}

// MARK: - Private Method

extension MovieDetailViewModel {
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

extension MovieDetailViewModel {
  func commentDateString(timestamp: Double) -> String {
    let formatter = DateFormatter.custom("yyyy-MM-dd HH:mm:ss")
    return formatter.string(from: Date(timeIntervalSince1970: timestamp))
  }
}
