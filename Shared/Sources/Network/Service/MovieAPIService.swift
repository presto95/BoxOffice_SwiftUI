//
//  MovieAPIService.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation
import Combine

final class MovieAPIService: MovieAPIServiceProtocol { 
  private let networkManager: NetworkManagerProtocol

  init(networkManager: NetworkManagerProtocol = NetworkManager()) {
    self.networkManager = networkManager
  }

  func imageDataPublisher(fromURLString urlString: String) -> AnyPublisher<Data, MovieAPIError> {
    guard let imageData = ImageCache.value(forKey: urlString) else {
      return Just(urlString)
        .setFailureType(to: Error.self)
        .flatMap(networkManager.publisher(fromURLString:))
        .mapError { _ in MovieAPIError.imageDataRequestFailed }
        .handleEvents(receiveOutput: { data in
          ImageCache.add(data, forKey: urlString)
        })
        .eraseToAnyPublisher()
    }

    return Just(imageData)
      .setFailureType(to: MovieAPIError.self)
      .eraseToAnyPublisher()
  }

  func moviesPublisher(with sortMethod: SortMethod) -> AnyPublisher<MoviesResponseModel, MovieAPIError> {
    Just(sortMethod)
      .map(\.rawValue)
      .map(String.init)
      .map { ["order_type": $0] }
      .map(MoviesTarget.init)
      .setFailureType(to: Error.self)
      .flatMap(networkManager.publisher(from:))
      .decode(type: MoviesResponseModel.self, decoder: JSONDecoder())
      .mapError { _ in MovieAPIError.moviesRequestFailed }
      .eraseToAnyPublisher()
  }

  func movieDetailPublisher(withMovieID movieID: String) -> AnyPublisher<MovieDetailResponseModel, MovieAPIError> {
    Just(movieID)
      .map { ["id": $0] }
      .map(MovieTarget.init)
      .setFailureType(to: Error.self)
      .flatMap(networkManager.publisher(from:))
      .decode(type: MovieDetailResponseModel.self, decoder: JSONDecoder())
      .mapError { _ in MovieAPIError.movieDetailRequestFailed }
      .eraseToAnyPublisher()
  }

  func commentsPublisher(withMovieID movieID: String) -> AnyPublisher<CommentsResponseModel, MovieAPIError> {
    Just(movieID)
      .map { ["movie_id": $0] }
      .map(CommentsTarget.init)
      .setFailureType(to: Error.self)
      .flatMap(networkManager.publisher(from:))
      .decode(type: CommentsResponseModel.self, decoder: JSONDecoder())
      .mapError { _ in MovieAPIError.commentsRequestFailed }
      .eraseToAnyPublisher()
  }

  func commentPostingPublisher(with comment: Comment) -> AnyPublisher<CommentPostingResponseModel, MovieAPIError> {
    Just(comment)
      .encode(encoder: JSONEncoder())
      .map(CommentPostingTarget.init)
      .flatMap(networkManager.publisher(from:))
      .decode(type: CommentPostingResponseModel.self, decoder: JSONDecoder())
      .mapError { _ in MovieAPIError.commentPostingRequestFailed }
      .eraseToAnyPublisher()
  }
}
