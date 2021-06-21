//
//  NetworkManagerProtocol.swift
//  BoxOffice
//
//  Created by Presto on 2021/06/21.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
  func publisher(from target: Target) -> AnyPublisher<Data, Error>
  func publisher(fromURLString urlString: String) -> AnyPublisher<Data, Error>
}
