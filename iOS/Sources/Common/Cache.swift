//
//  ImageCache.swift
//  BoxOffice_SwiftUI
//
//  Created by Presto on 2019/10/23.
//  Copyright © 2019 presto. All rights reserved.
//

import Foundation

protocol Cache {
    associatedtype Key
    associatedtype Value
    
    static func add(_ value: Value, forKey key: Key)
    static func remove(forKey key: Key)
    static func value(forKey key: Key) -> Value?
}

final class ImageCache: Cache {
    private static let cache = NSCache<NSString, NSData>()
    
    static func add(_ value: Data, forKey key: String) {
        cache.setObject(value as NSData, forKey: key as NSString)
    }
    
    static func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    static func value(forKey key: String) -> Data? {
        guard let data = cache.object(forKey: key as NSString) else { return nil }
        return Data(referencing: data)
    }
}
