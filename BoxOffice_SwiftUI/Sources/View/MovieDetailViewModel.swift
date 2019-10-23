//
//  MovieDetailViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieDetailViewModel: ObservableObject {

  private enum RequestType {

    case movie

    case comments
  }

  private let apiService: MovieAPIServiceType

  private let movieID: String

  private var cancellables = Set<AnyCancellable>()

  init(movieID: String, apiService: MovieAPIServiceType = MovieAPIService()) {
    self.movieID = movieID
    self.apiService = apiService

    isPresentedSubject
      .sink(receiveValue: { _ in
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
      .sink(receiveCompletion: { completion in
        if case .failure = completion {
          self.movieErrors.append(.movie)
        }
      }, receiveValue: { movieResponse in
        self.movie = movieResponse
        if let imageData = ImageCache.fetch(forKey: movieResponse.image) {
          self.posterImageData = imageData
        } else {
          self.requestImageData(from: movieResponse.image)
        }
      })
      .store(in: &cancellables)

    commentsSubject
      .compactMap { $0 }
      .tryMap { try $0.get() }
      .sink(receiveCompletion: { completion in
        if case .failure = completion {
          self.movieErrors.append(.comments)
        }
      }, receiveValue: { comments in
        self.comments = comments
      })
      .store(in: &cancellables)
  }

  // MARK: - Inputs

  func setPresented() {
    isPresentedSubject.send(Void())
  }

  func setShowsCommentPosting() {
    showsCommentPostingSubject.send(true)
  }

  // MARK: - Outputs

  @Published var isLoading = false

  @Published var showsCommentPosting = false

  @Published var movie: MovieResponse = .dummy

  @Published var comments: [CommentsResponse.Comment] = []

  @Published var posterImageData: Data = Data()

  @Published var movieErrors: [MovieError] = []

  // MARK: - Subjects

  private let isPresentedSubject = CurrentValueSubject<Void?, Never>(nil)

  private let isLoadingSubject = CurrentValueSubject<(Bool, Bool)?, Never>(nil)

  private let showsCommentPostingSubject = CurrentValueSubject<Bool?, Never>(nil)

  private let movieResponseSubject = CurrentValueSubject<Result<MovieResponse, Error>?, Never>(nil)

  private let commentsSubject = CurrentValueSubject<Result<[CommentsResponse.Comment], Error>?, Never>(nil)
}

extension MovieDetailViewModel {

  func requestData() {
    movieErrors = []
    apiService.requestMovie(id: movieID)
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveSubscription: { _ in
        self.changeLoading(true, to: .movie)
      })
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          self.movieResponseSubject.send(.failure(error))
        }
        self.changeLoading(false, to: .movie)
      }, receiveValue: { movieResponse in
        self.movieResponseSubject.send(.success(movieResponse))
      })
      .store(in: &cancellables)

    apiService.requestComments(movieID: movieID)
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveSubscription: { _ in
        self.changeLoading(true, to: .comments)
      })
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          self.commentsSubject.send(.failure(error))
        }
        self.changeLoading(false, to: .comments)
      }, receiveValue: { commentsResponse in
        self.commentsSubject.send(.success(commentsResponse.comments))
      })
      .store(in: &cancellables)
  }

  func requestImageData(from urlString: String) {
    Just(urlString)
      .receive(on: DispatchQueue.global())
      .compactMap { URL(string: $0) }
      .tryMap { try Data(contentsOf: $0) }
      .receive(on: DispatchQueue.main)
      .replaceError(with: Data())
      .sink(receiveValue: { imageData in
        self.posterImageData = imageData
        ImageCache.add(imageData, forKey: urlString)
      })
      .store(in: &self.cancellables)
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
