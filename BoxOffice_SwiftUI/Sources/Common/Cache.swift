//
//  ImageCache.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

protocol CacheType {

  associatedtype Key

  associatedtype Value

  func add(_: Value, forKey: Key)

  func remove(forKey: Key)

  func fetch(forKey: Key) -> Value?
}

final class ImageCache: CacheType {

  static let shared = ImageCache()

  private init() { }

  private let cache = NSCache<NSString, NSData>()

  func add(_ imageData: Data, forKey key: String) {
    cache.setObject(imageData as NSData, forKey: key as NSString)
  }

  func remove(forKey key: String) {
    cache.removeObject(forKey: key as NSString)
  }

  func fetch(forKey key: String) -> Data? {
    guard let data = cache.object(forKey: key as NSString) else { return nil }
    return Data(referencing: data)
  }
}
