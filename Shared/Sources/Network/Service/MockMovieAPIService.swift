//
//  MockMovieAPIService.swift
//  BoxOffice
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation
import Combine

final class MockMovieAPIService: MovieAPIServiceProtocol {
    private let networkManager: NetworkManagerProtocol = MockNetworkManager()
    
    func imageDataPublisher(fromURLString urlString: String) -> AnyPublisher<Data, MovieAPIError> {
        networkManager.publisher(fromURLString: urlString)
            .mapError { _ in MovieAPIError.imageDataRequestFailed }
            .eraseToAnyPublisher()
    }
    
    func moviesPublisher(with sortMethod: SortMethod) -> AnyPublisher<MoviesResponseModel, MovieAPIError> {
        Just(MoviesResponseModel.dummy)
            .setFailureType(to: MovieAPIError.self)
            .eraseToAnyPublisher()
    }
    
    func movieDetailPublisher(withMovieID: String) -> AnyPublisher<MovieDetailResponseModel, MovieAPIError> {
        Just(MovieDetailResponseModel.dummy)
            .setFailureType(to: MovieAPIError.self)
            .eraseToAnyPublisher()
    }
    
    func commentsPublisher(withMovieID: String) -> AnyPublisher<CommentsResponseModel, MovieAPIError> {
        Just(CommentsResponseModel.dummy)
            .setFailureType(to: MovieAPIError.self)
            .eraseToAnyPublisher()
    }
    
    func commentPostingPublisher(with: Comment) -> AnyPublisher<CommentPostingResponseModel, MovieAPIError> {
        Just(CommentPostingResponseModel.dummy)
            .setFailureType(to: MovieAPIError.self)
            .eraseToAnyPublisher()
    }
}
