/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation

public struct JSONCodingKeys: CodingKey {
  public var stringValue: String

  public init(stringValue: String) {
    self.stringValue = stringValue
  }

  public var intValue: Int?

  public init?(intValue: Int) {
    self.init(stringValue: "\(intValue)")
    self.intValue = intValue
  }
}

public extension KeyedDecodingContainer {

  func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> [String: Any] {
    let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
    return try container.decode(type)
  }

  func decode(_ type: Array<Any>.Type, forKey key: K) throws -> [Any] {
    var container = try self.nestedUnkeyedContainer(forKey: key)
    return try container.decode(type)
  }

  func decode(_ type: Dictionary<String, Any>.Type) throws -> [String: Any] {
    var dictionary = [String: Any]()

    for key in allKeys {
      if let boolValue = try? decode(Bool.self, forKey: key) {
        dictionary[key.stringValue] = boolValue
      } else if let stringValue = try? decode(String.self, forKey: key) {
        dictionary[key.stringValue] = stringValue
      } else if let intValue = try? decode(Int.self, forKey: key) {
        dictionary[key.stringValue] = intValue
      } else if let doubleValue = try? decode(Double.self, forKey: key) {
        dictionary[key.stringValue] = doubleValue
      } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
        dictionary[key.stringValue] = nestedDictionary
      } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
        dictionary[key.stringValue] = nestedArray
      }
    }
    return dictionary
  }
}

public extension UnkeyedDecodingContainer {

  mutating func decode(_ type: Array<Any>.Type) throws -> [Any] {
    var array: [Any] = []
    while isAtEnd == false {
      if let value = try? decode(Bool.self) {
        array.append(value)
      } else if let value = try? decode(Double.self) {
        array.append(value)
      } else if let value = try? decode(String.self) {
        array.append(value)
      } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
        array.append(nestedDictionary)
      } else if let nestedArray = try? decode(Array<Any>.self) {
        array.append(nestedArray)
      }
    }
    return array
  }

  mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> [String: Any] {
    let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
    return try nestedContainer.decode(type)
  }
}

public extension KeyedEncodingContainerProtocol where Key == JSONCodingKeys {
  mutating func encode(_ value: [String: Any]) throws {
    try value.forEach({ (key, value) in
      let key = JSONCodingKeys(stringValue: key)
      switch value {
      case let value as Bool:
        try encode(value, forKey: key)
      case let value as Int:
        try encode(value, forKey: key)
      case let value as String:
        try encode(value, forKey: key)
      case let value as Double:
        try encode(value, forKey: key)
      case let value as CGFloat:
        try encode(value, forKey: key)
      case let value as [String: Any]:
        try encode(value, forKey: key)
      case let value as [Any]:
        try encode(value, forKey: key)
      case Optional<Any>.none:
        try encodeNil(forKey: key)
      default:
        throw EncodingError.invalidValue(
          value,
          EncodingError.Context(codingPath: codingPath + [key], debugDescription: "Invalid JSON value")
        )
      }
    })
  }
}

public extension KeyedEncodingContainerProtocol {
  mutating func encode(_ value: [String: Any]?, forKey key: Key) throws {
    if value != nil {
      var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
      try container.encode(value!)
    }
  }

  mutating func encode(_ value: [Any]?, forKey key: Key) throws {
    if value != nil {
      var container = self.nestedUnkeyedContainer(forKey: key)
      try container.encode(value!)
    }
  }
}

public extension UnkeyedEncodingContainer {
  mutating func encode(_ value: [Any]) throws {
    try value.enumerated().forEach({ (index, value) in
      switch value {
      case let value as Bool:
        try encode(value)
      case let value as Int:
        try encode(value)
      case let value as String:
        try encode(value)
      case let value as Double:
        try encode(value)
      case let value as CGFloat:
        try encode(value)
      case let value as [String: Any]:
        try encode(value)
      case let value as [Any]:
        try encode(value)
      case Optional<Any>.none:
        try encodeNil()
      default:
        let keys = JSONCodingKeys(intValue: index).map({ [ $0 ] }) ?? []
        throw EncodingError.invalidValue(
          value,
          EncodingError.Context(codingPath: codingPath + keys, debugDescription: "Invalid JSON value"
        ))
      }
    })
  }

  mutating func encode(_ value: [String: Any]) throws {
    var nestedContainer = self.nestedContainer(keyedBy: JSONCodingKeys.self)
    try nestedContainer.encode(value)
  }
}
