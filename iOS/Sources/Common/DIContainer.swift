//
//  DIContainer.swift
//  BoxOffice
//
//  Created by Presto on 2021/07/11.
//  Copyright © 2021 presto. All rights reserved.
//

import Foundation

final class DIContainer {
    private var dependencies: [String: Any] = [:]
    private init() {}

    static let shared = DIContainer()

    func register<Dependency>(_ dependency: Dependency) {
        let key = self.key(dependency)
        register(dependency, forKey: key)
    }

    func register<Key, Dependency>(_ dependency: Dependency, forKey key: Key) {
        let key = self.key(key)
        register(dependency, forKey: key)
    }

    func resolve<Dependency>(_ dependency: Dependency.Type) -> Dependency? {
        let key = self.key(dependency)
        return resolve(dependency, forKey: key)
    }

    func resolve<Key, Dependency>(_ dependency: Dependency.Type, forKey key: Key) -> Dependency? {
        let key = self.key(key)
        return resolve(dependency, forKey: key)
    }
}

private extension DIContainer {
    func key<Value>(_ value: Value) -> String {
        return String(describing: value).components(separatedBy: ".").last ?? ""
    }

    func register<Dependency>(_ dependency: Dependency, forKey key: String) {
        if dependencies[key] == nil {
            dependencies[key] = dependency
        } else {
            #if DEBUG
            print("Dependency for '\(key)' is already registered. It will be replaced.")
            #endif
            dependencies[key] = dependency
        }
    }

    func resolve<Dependency>(_ dependency: Dependency.Type, forKey key: String) -> Dependency? {
        if let dependency = dependencies[key] as? Dependency {
            return dependency
        } else {
            #if DEBUG
            print("Dependency for '\(key)' is not registered.")
            #endif
            return nil
        }
    }
}
