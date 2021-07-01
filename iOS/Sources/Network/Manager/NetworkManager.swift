//
//  NetworkManager.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation
import Combine

final class NetworkManager: NetworkManagerProtocol {
    func publisher(from target: Target) -> AnyPublisher<Data, Error> {
        var components = URLComponents()
        components.scheme = target.routerVersion.scheme
        components.host = target.routerVersion.host
        components.path = target.paths.map { "/\($0)" }.joined()
        components.queryItems = target.parameter?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            return Empty().eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url, timeoutInterval: 1)
        request.httpMethod = target.method.rawValue
        request.httpBody = target.body
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(1)
            .mapError { $0 as Error }
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    func publisher(fromURLString urlString: String) -> AnyPublisher<Data, Error> {
        return Just(urlString)
            .compactMap(URL.init)
            .setFailureType(to: URLError.self)
            .receive(on: DispatchQueue.global(qos: .utility))
            .flatMap(URLSession.shared.dataTaskPublisher(for:))
            .retry(1)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
