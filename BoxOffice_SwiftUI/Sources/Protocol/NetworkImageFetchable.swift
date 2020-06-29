//
//  NetworkImageFetchable.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/11/05.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

protocol NetworkImageFetchable {}

extension NetworkImageFetchable {
  func networkImageData(from urlString: String) -> AnyPublisher<Data, Error> {
    if let imageData = ImageCache.value(forKey: urlString) {
      return Just(imageData)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    } else {
      return Just(urlString)
        .compactMap { URL(string: $0) }
        .receive(on: DispatchQueue.global(qos: .utility))
        .tryMap { try Data(contentsOf: $0) }
        .retry(1)
        .handleEvents(receiveOutput: { data in
          ImageCache.add(data, forKey: urlString)
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
  }
}
