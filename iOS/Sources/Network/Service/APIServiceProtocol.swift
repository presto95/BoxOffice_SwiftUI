//
//  APIProtocol.swift
//  BoxOffice
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation
import Combine

protocol APIProtocol {
    func imageDataPublisher(fromURLString urlString: String) -> ImageDataPublisher
    func moviesPublisher(with sortMethod: SortMethod) -> MoviesPublisher
    func movieDetailPublisher(withMovieID: String) -> MovieDetailPublisher
    func commentsPublisher(withMovieID: String) -> CommentsPublisher
    func commentPostingPublisher(with: Comment) -> CommentPostingPublisher
}

typealias ImageData = Data
typealias ImageDataPublisher = AnyPublisher<ImageData, APIError>
typealias MoviesPublisher = AnyPublisher<MoviesResponseModel, APIError>
typealias MovieDetailPublisher = AnyPublisher<MovieDetailResponseModel, APIError>
typealias CommentsPublisher = AnyPublisher<CommentsResponseModel, APIError>
typealias CommentPostingPublisher = AnyPublisher<CommentPostingResponseModel, APIError>
