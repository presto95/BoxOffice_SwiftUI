//
//  MovieAPIService.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

protocol MovieAPIServiceType {

  func movies(orderType: OrderType) -> AnyPublisher<MoviesResponse, Error>

  func movie(id: String) -> AnyPublisher<MovieResponse, Error>

  func comments(movieID: String) -> AnyPublisher<CommentsResponse, Error>

  func commentPosting(_ comment: Comment) -> AnyPublisher<CommentResponse, Error>
}

final class MovieAPIService: MovieAPIServiceType {

  private let networkManager: NetworkManagerType

  init(networkManager: NetworkManagerType = NetworkManager()) {
    self.networkManager = networkManager
  }

  func movies(orderType: OrderType) -> AnyPublisher<MoviesResponse, Error> {
    Just(orderType)
      .map(\.rawValue)
      .map(String.init)
      .map { MoviesTarget(parameter: ["order_type": $0]) }
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: MoviesResponse.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func movie(id: String) -> AnyPublisher<MovieResponse, Error> {
    Just(id)
      .map { MovieTarget(parameter: ["id": $0]) }
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: MovieResponse.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func comments(movieID: String) -> AnyPublisher<CommentsResponse, Error> {
    Just(movieID)
      .map { CommentsTarget(parameter: ["movie_id": $0]) }
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: CommentsResponse.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func commentPosting(_ comment: Comment) -> AnyPublisher<CommentResponse, Error> {
    Just(comment)
      .encode(encoder: JSONEncoder())
      .map { CommentPostingTarget(parameter: nil, body: $0) }
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: CommentResponse.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
