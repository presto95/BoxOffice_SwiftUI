//
//  NetworkImageFetchable.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/11/05.
//  Copyright © 2019 presto. All rights reserved.
//

import Combine
import Foundation

protocol NetworkImageFetchable { }

extension NetworkImageFetchable {

  func networkImageData(from urlString: String) -> AnyPublisher<Data, Error> {
    if let imageData = ImageCache.shared.fetch(forKey: urlString) {
      return Just(imageData)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    } else {
      return Just(urlString)
        .compactMap { URL(string: $0) }
        .receive(on: DispatchQueue.global())
        .tryMap { try Data(contentsOf: $0) }
        .handleEvents(receiveOutput: { data in
          ImageCache.shared.add(data, forKey: urlString)
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
  }
}
