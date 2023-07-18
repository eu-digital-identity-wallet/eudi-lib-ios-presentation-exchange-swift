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

public class DictionaryEncoder {

  private let encoder = JSONEncoder()

  public init() {
  }

  public var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
    get { return encoder.dateEncodingStrategy }
    set { encoder.dateEncodingStrategy = newValue }
  }

  public var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
    get { return encoder.dataEncodingStrategy }
    set { encoder.dataEncodingStrategy = newValue }
  }

  public var nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy {
    get { return encoder.nonConformingFloatEncodingStrategy }
    set { encoder.nonConformingFloatEncodingStrategy = newValue }
  }

  public var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
    get { return encoder.keyEncodingStrategy }
    set { encoder.keyEncodingStrategy = newValue }
  }

  public func encode<T>(_ value: T) throws -> [String: Any] where T: Encodable {
    let data = try encoder.encode(value)
    return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
  }
}
