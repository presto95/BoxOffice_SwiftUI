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
  func networkImageData(from urlString: String) -> AnyPublisher<Data?, Never> {
    if let imageData = ImageCache.value(forKey: urlString) {
      return Just(imageData)
        .eraseToAnyPublisher()
    } else {
      return Just(urlString)
        .compactMap { URL(string: $0) }
        .receive(on: DispatchQueue.global(qos: .utility))
        .map { try? Data(contentsOf: $0) }
        .retry(1)
        .handleEvents(receiveOutput: { data in
          if let data = data {
            ImageCache.add(data, forKey: urlString)
          }
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
  }
}
