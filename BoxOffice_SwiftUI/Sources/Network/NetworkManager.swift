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

  func request(_ router: RouterType) -> AnyPublisher<(data: Data, response: URLResponse), Error>
}

final class NetworkManager: NetworkManagerType {

  func request(_ router: RouterType) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    var components = URLComponents()
    components.scheme = router.routerVersion.scheme
    components.host = router.routerVersion.host
    components.path = router.path
    components.queryItems = router.parameter
    guard let url = components.url else {
      return Empty(completeImmediately: true)
        .eraseToAnyPublisher()
    }
    var request = URLRequest(url: url, timeoutInterval: 1)
    request.httpMethod = router.method.rawValue
    request.httpBody = router.body
    return URLSession.shared.dataTaskPublisher(for: request)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
