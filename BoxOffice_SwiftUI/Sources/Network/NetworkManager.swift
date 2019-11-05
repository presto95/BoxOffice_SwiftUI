//
//  NetworkManager.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

protocol NetworkManagerType {

  func request(_ router: TargetType) -> AnyPublisher<(data: Data, response: URLResponse), Error>
}

final class NetworkManager: NetworkManagerType {

  func request(_ target: TargetType) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
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
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
