//
//  MovieViewModel.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

final class MovieViewModel: ObservableObject {
  enum PresentationType {
    case table

    case collection
  }

  private let apiService: MovieAPIServiceType

  private var cancellables = Set<AnyCancellable>()

  init(apiService: MovieAPIServiceType = MovieAPIService()) {
    self.apiService = apiService

    isPresentedSubject
      .compactMap { $0 }
      .filter { $0 }
      .removeDuplicates()
      .map { _ in OrderType.reservation }
      .sink(receiveValue: { orderType in
        self.orderTypeSubject.send(orderType)
      })
      .store(in: &cancellables)

    orderTypeSubject
      .compactMap { $0 }
      .removeDuplicates()
      .sink(receiveValue: { orderType in
        self.orderType = orderType
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

  func setOrderType(_ orderType: OrderType) {
    orderTypeSubject.send(orderType)
  }

  func setShowsSortActionSheet() {
    showsSortActionSheetSubject.send(true)
  }

  func retryMovieRequest() {
    requestMovies()
  }

  // MARK: - Outputs

  @Published var presentationType = MovieViewModel.PresentationType.table

  @Published var showsSortActionSheet = false

  @Published var isLoading = false

  @Published var orderType = OrderType.reservation

  @Published var movies = [MoviesResponse.Movie]()

  @Published var movieErrors = [MovieError]()

  var orderTypeDescription: String { orderType.description }

  // MARK: - Subjects

  private let isPresentedSubject = CurrentValueSubject<Bool?, Never>(nil)

  private let showsSortActionSheetSubject = CurrentValueSubject<Bool?, Never>(nil)

  private let orderTypeSubject = CurrentValueSubject<OrderType?, Never>(nil)
}

extension MovieViewModel {
  private func requestMovies() {
    movieErrors = []
    isLoading = true
    apiService.movies(orderType: orderType)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        if case .failure = completion {
          self.movieErrors.append(.movies)
        }
        self.isLoading = false
      }, receiveValue: { moviesResponse in
        self.movies = moviesResponse.movies
      })
      .store(in: &cancellables)
  }
}
