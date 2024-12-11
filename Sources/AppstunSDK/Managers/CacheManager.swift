//
//  File.swift
//  
//
//  Created by Bora Erdem on 5.02.2024.
//

import Foundation

public final class CacheManager {
    
    public static let defaults = UserDefaults.standard
    
    public static func cache<T: Codable>(value: T, forKey key: String) {
        guard let data = try?  JSONEncoder().encode(value) else {return}
        defaults.set(data, forKey: key)
    }
    
    public static func getCachedValue<T: Codable>(forKey key: String) -> T? {
        guard
            let data = defaults.value(forKey: key) as? NSData,
            let item = try? JSONDecoder().decode(T.self, from: data as Data)
        else {return nil}
        return item
    }
    
    public static func clearCache(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    public enum Key: String {
        case historyIDS
    }
}
