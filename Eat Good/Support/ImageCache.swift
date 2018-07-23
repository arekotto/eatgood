//
//  ImageCache.swift
//  Eat Good
//
//  Created by Arek Otto on 12/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation

class Cache<T> {
    
    private var keys = [Int]()
    private var cachedObjects = [Int: T]()
    
    let maxSize: UInt
    
    init(maxSize: UInt) {
        self.maxSize = maxSize
    }
    
    func object(forKey key: Int) -> T? {
        return cachedObjects[key]
    }
    
    func insert(object: T, forKey key: Int) {
        if cachedObjects.count == maxSize {
            cachedObjects.removeValue(forKey: keys.removeFirst())
        }
        cachedObjects[key] = object
        keys.append(key)
    }
    
    func removeAll() {
        keys.removeAll()
        cachedObjects.removeAll()
    }
}
