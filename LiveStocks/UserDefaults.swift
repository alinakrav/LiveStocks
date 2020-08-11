//
//  UserDefaults.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-08-09.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

// methods to easily get/store data with NSDefaults
extension UserDefaults {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ErrorEnum.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ErrorEnum.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ErrorEnum.unableToDecode
        }
    }
}

enum ErrorEnum: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
