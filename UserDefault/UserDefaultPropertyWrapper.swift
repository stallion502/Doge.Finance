//
//  UserDefaultPropertyWrapper.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    var key: String
    var wrappedValue: T? {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { UserDefaults.standard.object(forKey: key) as? T }
    }
}

@propertyWrapper
struct EnumDefault<E: RawRepresentable> {
    var key: String
    var wrappedValue: E? {
        get  {
            guard let raw = UserDefaults.standard.object(forKey: key) as? E.RawValue else {
                return nil
            }
            return E.init(rawValue: raw)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value.rawValue, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}
