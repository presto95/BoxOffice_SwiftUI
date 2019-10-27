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
    let router = MoviesTarget(parameter: ["order_type": String(orderType.rawValue)])
    return networkManager.request(router)
      .map { $0.data }
      .tryMap { try self.decode($0, to: MoviesResponse.self) }
      .eraseToAnyPublisher()
  }

  func requestMovie(id: String) -> AnyPublisher<MovieResponse, Error> {
    let router = MovieTarget(parameter: ["id": id])
    return networkManager.request(router)
      .map { $0.data }
      .tryMap { try self.decode($0, to: MovieResponse.self) }
      .eraseToAnyPublisher()
  }

  func requestComments(movieID: String) -> AnyPublisher<CommentsResponse, Error> {
    let router = CommentsTarget(parameter: ["movie_id": movieID])
    return networkManager.request(router)
      .map { $0.data }
      .tryMap { try self.decode($0, to: CommentsResponse.self) }
      .eraseToAnyPublisher()
  }

  func postComment(_ comment: Comment) -> AnyPublisher<CommentResponse, Error> {
    let router = CommentPostingTarget(parameter: nil, body: try? JSONEncoder().encode(comment))
    return networkManager.request(router)
      .map { $0.data }
      .tryMap { try self.decode($0, to: CommentResponse.self) }
      .eraseToAnyPublisher()
  }
}

extension MovieAPIService {

  private func decode<Decode: Decodable>(_ data: Data, to type: Decode.Type) throws -> Decode {
    do {
      return try JSONDecoder().decode(Decode.self, from: data)
    } catch {
      throw error
    }
  }
}
