//
//  MovieAPIService.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import UIKit
import Combine

protocol MovieAPIServiceProtocol {
  func requestImageData(fromURLString urlString: String) -> AnyPublisher<Data, Error>
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

  func requestImageData(fromURLString urlString: String) -> AnyPublisher<Data, Error> {
    guard let imageData = ImageCache.value(forKey: urlString) else {
      return Just(urlString)
        .setFailureType(to: Error.self)
        .flatMap(networkManager.request(fromURLString:))
        .handleEvents(receiveOutput: { data in
          ImageCache.add(data, forKey: urlString)
        })
        .eraseToAnyPublisher()
    }

    return Just(imageData)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }

  func requestMovies(sortMethod: SortMethod) -> AnyPublisher<MoviesResponseModel, Error> {
    Just(sortMethod)
      .map(\.rawValue)
      .map(String.init)
      .map { ["order_type": $0] }
      .map(MoviesTarget.init)
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(from:))
      .decode(type: MoviesResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func requestMovieDetail(movieID: String) -> AnyPublisher<MovieDetailResponseModel, Error> {
    Just(movieID)
      .map { ["id": $0] }
      .map(MovieTarget.init)
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(from:))
      .decode(type: MovieDetailResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func requestComments(movieID: String) -> AnyPublisher<CommentsResponseModel, Error> {
    Just(movieID)
      .map { ["movie_id": $0] }
      .map(CommentsTarget.init)
      .setFailureType(to: Error.self)
      .flatMap(networkManager.request(from:))
      .decode(type: CommentsResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func requestCommentPosting(comment: Comment) -> AnyPublisher<CommentPostingResponseModel, Error> {
    Just(comment)
      .encode(encoder: JSONEncoder())
      .map(CommentPostingTarget.init)
      .flatMap(networkManager.request(from:))
      .decode(type: CommentPostingResponseModel.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
