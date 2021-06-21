//
//  MovieAPIServiceProtocol.swift
//  BoxOffice
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation
import Combine

protocol MovieAPIServiceProtocol {
  func imageDataPublisher(fromURLString urlString: String) -> AnyPublisher<Data, MovieAPIError>
  func moviesPublisher(with sortMethod: SortMethod) -> AnyPublisher<MoviesResponseModel, MovieAPIError>
  func movieDetailPublisher(withMovieID: String) -> AnyPublisher<MovieDetailResponseModel, MovieAPIError>
  func commentsPublisher(withMovieID: String) -> AnyPublisher<CommentsResponseModel, MovieAPIError>
  func commentPostingPublisher(with: Comment) -> AnyPublisher<CommentPostingResponseModel, MovieAPIError>
}
