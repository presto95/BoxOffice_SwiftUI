//
//  ImageCache.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

final class ImageCache {

  private static let cache = NSCache<NSString, NSData>()

  static func add(_ imageData: Data, forKey key: String) {
    cache.setObject(imageData as NSData, forKey: key as NSString)
  }

  static func remove(forKey key: String) {
    cache.removeObject(forKey: key as NSString)
  }

  static func fetch(forKey key: String) -> Data? {
    guard let data = cache.object(forKey: key as NSString) else { return nil }
    return Data(referencing: data)
  }
}
