//
//  MockNetworkManager.swift
//  BoxOffice
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation
import Combine

final class MockNetworkManager: NetworkManagerProtocol {
    func publisher(from target: Target) -> AnyPublisher<Data, Error> {
        Just(Data())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func publisher(fromURLString urlString: String) -> AnyPublisher<Data, Error> {
        Just(Data())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
