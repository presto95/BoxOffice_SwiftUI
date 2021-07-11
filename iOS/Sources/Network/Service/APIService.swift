//
//  APIService.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/16.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation
import Combine

final class APIService: APIProtocol { 
    private let networkManager: NetworkManagerProtocol?
    
    init() {
        self.networkManager = DIContainer.shared.resolve(NetworkManager.self)
    }
    
    func imageDataPublisher(fromURLString urlString: String) -> ImageDataPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        guard let imageData = ImageCache.value(forKey: urlString) else {
            return Just(urlString)
                .setFailureType(to: Error.self)
                .flatMap(networkManager.publisher(fromURLString:))
                .mapError { _ in APIError.imageDataRequestFailed }
                .handleEvents(receiveOutput: { data in
                    ImageCache.add(data, forKey: urlString)
                })
                .eraseToAnyPublisher()
        }
        
        return Just(imageData)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    func moviesPublisher(with sortMethod: SortMethod) -> MoviesPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        return Just(sortMethod)
            .map(\.rawValue)
            .map(String.init)
            .map { ["order_type": $0] }
            .map(MoviesTarget.init)
            .setFailureType(to: Error.self)
            .flatMap(networkManager.publisher(from:))
            .decode(type: MoviesResponseModel.self, decoder: JSONDecoder())
            .mapError { _ in APIError.moviesRequestFailed }
            .eraseToAnyPublisher()
    }
    
    func movieDetailPublisher(withMovieID movieID: String) -> MovieDetailPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        return Just(movieID)
            .map { ["id": $0] }
            .map(MovieTarget.init)
            .setFailureType(to: Error.self)
            .flatMap(networkManager.publisher(from:))
            .decode(type: MovieDetailResponseModel.self, decoder: JSONDecoder())
            .mapError { _ in APIError.movieDetailRequestFailed }
            .eraseToAnyPublisher()
    }
    
    func commentsPublisher(withMovieID movieID: String) -> CommentsPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        return Just(movieID)
            .map { ["movie_id": $0] }
            .map(CommentsTarget.init)
            .setFailureType(to: Error.self)
            .flatMap(networkManager.publisher(from:))
            .decode(type: CommentsResponseModel.self, decoder: JSONDecoder())
            .mapError { _ in APIError.commentsRequestFailed }
            .eraseToAnyPublisher()
    }
    
    func commentPostingPublisher(with comment: Comment) -> CommentPostingPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        return Just(comment)
            .encode(encoder: JSONEncoder())
            .map(CommentPostingTarget.init)
            .flatMap(networkManager.publisher(from:))
            .decode(type: CommentPostingResponseModel.self, decoder: JSONDecoder())
            .mapError { _ in APIError.commentPostingRequestFailed }
            .eraseToAnyPublisher()
    }
}
