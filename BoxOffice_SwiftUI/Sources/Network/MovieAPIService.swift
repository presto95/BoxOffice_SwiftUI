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

  func requestMovies(orderType: OrderType) -> AnyPublisher<MoviesResponse, Error>

  func requestMovie(id: String) -> AnyPublisher<MovieResponse, Error>

  func requestComments(movieID: String) -> AnyPublisher<CommentsResponse, Error>

  func postComment(_ comment: Comment) -> AnyPublisher<CommentResponse, Error>
}

final class MovieAPIService: MovieAPIServiceType {

  private let networkManager: NetworkManagerType

  init(networkManager: NetworkManagerType = NetworkManager()) {
    self.networkManager = networkManager
  }

  func requestMovies(orderType: OrderType) -> AnyPublisher<MoviesResponse, Error> {
    Just(orderType)
      .map { "\($0.rawValue)" }
      .map { MoviesTarget(parameter: ["order_type": $0]) }
      .setFailureType(to: Error.self)
      .flatMap { self.networkManager.request($0) }
      .map { $0.data }
      .tryMap { try self.decode($0, to: MoviesResponse.self) }
      .eraseToAnyPublisher()
  }

  func requestMovie(id: String) -> AnyPublisher<MovieResponse, Error> {
    Just(id)
      .map { MovieTarget(parameter: ["id": $0]) }
      .setFailureType(to: Error.self)
      .flatMap { self.networkManager.request($0) }
      .map { $0.data }
      .tryMap { try self.decode($0, to: MovieResponse.self) }
      .eraseToAnyPublisher()
  }

  func requestComments(movieID: String) -> AnyPublisher<CommentsResponse, Error> {
    Just(movieID)
      .map { CommentsTarget(parameter: ["movie_id": $0]) }
      .setFailureType(to: Error.self)
      .flatMap { self.networkManager.request($0) }
      .map { $0.data }
      .tryMap { try self.decode($0, to: CommentsResponse.self) }
      .eraseToAnyPublisher()
  }

  func postComment(_ comment: Comment) -> AnyPublisher<CommentResponse, Error> {
    Just(comment)
      .tryMap { try JSONEncoder().encode($0) }
      .map { CommentPostingTarget(parameter: nil, body: $0) }
      .flatMap { self.networkManager.request($0) }
      .map { $0.data }
      .tryMap { try self.decode($0, to: CommentResponse.self) }
      .eraseToAnyPublisher()
  }
}

extension MovieAPIService {

  private func decode<Decode: Decodable>(_ data: Data, to type: Decode.Type) throws -> Decode {
    try JSONDecoder().decode(Decode.self, from: data)
  }
}
