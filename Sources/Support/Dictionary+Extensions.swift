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

public extension Dictionary {
  func filterValues(_ isIncluded: (Value) -> Bool) -> [Key: Value] {
    return filter { _, value in
      isIncluded(value)
    }
  }
}

public extension Dictionary where Key == String, Value == Any {

  static func from(localJSONfile name: String) -> Result<Self, JSONParseError> {
    let fileType = "json"
    guard let path = Bundle.module.path(forResource: name, ofType: fileType) else {
      return .failure(.fileNotFound(filename: name))
    }
    return from(JSONfile: URL(fileURLWithPath: path))
  }
}

internal enum DictionaryError: LocalizedError {
  case nilValue

  var errorDescription: String? {
    switch self {
    case .nilValue:
      return ".nilValue"
    }
  }
}

public func getStringValue(from metaData: [String: Any], for key: String) throws -> String {
  guard let value = metaData[key] as? String else {
    throw DictionaryError.nilValue
  }
  return value
}

public func getStringArrayValue(from metaData: [String: Any], for key: String) throws -> [String] {
    guard let value = metaData[key] as? [String] else {
        throw DictionaryError.nilValue
    }
    return value
}

public func == (lhs: [String: Any], rhs: [String: Any]) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public extension Dictionary where Key == String, Value == Any {

  var jsonData: Data? {
    return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
  }

  func toJSONString() -> String? {
    if let jsonData = jsonData {
      let jsonString = String(data: jsonData, encoding: .utf8)
      return jsonString
    }
    return nil
  }

  static func from(JSONfile url: URL) -> Result<Self, JSONParseError> {
    let data: Data
    do {
      data = try Data(contentsOf: url)
    } catch let error {
      return .failure(.dataInitialisation(error))
    }

    let jsonObject: Any
    do {
      jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
    } catch let error {
      return .failure(.jsonSerialization(error))
    }

    guard let jsonResult = jsonObject as? Self else {
      return .failure(.mappingFail(value: jsonObject, toType: Self.Type.self))
    }

    return .success(jsonResult)
  }
}
