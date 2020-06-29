//
//  MovieAPIService.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

protocol MovieAPIServiceProtocol {
  func requestMovies(sortMethod: SortMethod) -> AnyPublisher<MoviesResponseModel, Error>
  func requestMovieDetail(movieID: String) -> AnyPublisher<MovieDetailResponseModel, Error>
  func requestComments(movieID: String) -> AnyPublisher<CommentsResponseModel, Error>
  func requestCommentPosting(comment: Comment) -> AnyPublisher<CommentPostingResponseModel, Error>
}

final class MovieAPIService: MovieAPIServiceProtocol { 
  private let networkManager: NetworkManagerProtocol

  init(networkManager: NetworkManagerProtocol = NetworkManager()) {
    self.networkManager = networkManager
  }

  func requestMovies(sortMethod: SortMethod) -> AnyPublisher<MoviesResponseModel, Error> {
    Just(sortMethod)
      .map(\.rawValue)
      .map(String.init)
      .map { MoviesTarget(parameter: ["order_type": $0]) }
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: MoviesResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func requestMovieDetail(movieID: String) -> AnyPublisher<MovieDetailResponseModel, Error> {
    Just(movieID)
      .map { MovieTarget(parameter: ["id": $0]) }
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: MovieDetailResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func requestComments(movieID: String) -> AnyPublisher<CommentsResponseModel, Error> {
    Just(movieID)
      .map { CommentsTarget(parameter: ["movie_id": $0]) }
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: CommentsResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func requestCommentPosting(comment: Comment) -> AnyPublisher<CommentPostingResponseModel, Error> {
    Just(comment)
      .encode(encoder: JSONEncoder())
      .map { CommentPostingTarget(body: $0) }
      .flatMap(networkManager.request(_:))
      .map(\.data)
      .decode(type: CommentPostingResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
