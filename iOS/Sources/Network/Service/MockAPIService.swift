//
//  MockAPIService.swift
//  BoxOffice
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation
import Combine

final class MockAPIService: APIProtocol {
    private let networkManager: NetworkManagerProtocol = MockNetworkManager()
    
    func imageDataPublisher(fromURLString urlString: String) -> ImageDataPublisher {
        networkManager.publisher(fromURLString: urlString)
            .mapError { _ in APIError.imageDataRequestFailed }
            .eraseToAnyPublisher()
    }
    
    func moviesPublisher(with sortMethod: SortMethod) -> MoviesPublisher {
        Just(MoviesResponseModel.dummy)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    func movieDetailPublisher(withMovieID: String) -> MovieDetailPublisher {
        Just(MovieDetailResponseModel.dummy)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    func commentsPublisher(withMovieID: String) -> CommentsPublisher {
        Just(CommentsResponseModel.dummy)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    func commentPostingPublisher(with: Comment) -> CommentPostingPublisher {
        Just(CommentPostingResponseModel.dummy)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
