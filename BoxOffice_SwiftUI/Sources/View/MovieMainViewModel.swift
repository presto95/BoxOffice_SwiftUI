//
//  MovieMainViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieMainViewModel: ObservableObject {
  enum PresentationType {
    case table
    case collection
  }

  private let apiService: MovieAPIServiceProtocol

  private var cancellables = Set<AnyCancellable>()

  init(apiService: MovieAPIServiceProtocol = MovieAPIService()) {
    self.apiService = apiService

    isPresentedSubject
      .compactMap { $0 }
      .filter { $0 }
      .removeDuplicates()
      .map { _ in SortMethod.reservation }
      .sink(receiveValue: { sortMethod in
        self.sortMethodSubject.send(sortMethod)
      })
      .store(in: &cancellables)

    sortMethodSubject
      .compactMap { $0 }
      .removeDuplicates()
      .sink(receiveValue: { sortMethod in
        self.sortMethod = sortMethod
        self.requestMovies()
      })
      .store(in: &cancellables)

    showsSortActionSheetSubject
      .compactMap { $0 }
      .assign(to: \.showsSortActionSheet, on: self)
      .store(in: &cancellables)
  }

  // MARK: - Inputs

  func setPresented() {
    isPresentedSubject.send(true)
  }

  func setSortMethod(_ sortMethod: SortMethod) {
    sortMethodSubject.send(sortMethod)
  }

  func setShowsSortActionSheet() {
    showsSortActionSheetSubject.send(true)
  }

  func retryMovieRequest() {
    requestMovies()
  }

  // MARK: - Outputs

  @Published var presentationType = MovieMainViewModel.PresentationType.table
  @Published var showsSortActionSheet = false
  @Published var isLoading = false
  @Published var sortMethod = SortMethod.reservation
  @Published var movies = [MoviesResponseModel.Movie]()
  @Published var movieErrors = [MovieError]()

  var sortMethodDescription: String { sortMethod.description }

  // MARK: - Subjects

  private let isPresentedSubject = CurrentValueSubject<Bool?, Never>(nil)
  private let showsSortActionSheetSubject = CurrentValueSubject<Bool?, Never>(nil)
  private let sortMethodSubject = CurrentValueSubject<SortMethod?, Never>(nil)
}

extension MovieMainViewModel {
  private func requestMovies() {
    movieErrors = []
    isLoading = true
    apiService.requestMovies(sortMethod: sortMethod)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        if case .failure = completion {
          self.movieErrors.append(.moviesRequestFailed)
        }
        self.isLoading = false
      }, receiveValue: { moviesResponse in
        self.movies = moviesResponse.movies
      })
      .store(in: &cancellables)
  }
}
