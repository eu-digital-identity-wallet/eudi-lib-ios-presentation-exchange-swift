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
@preconcurrency import SwiftyJSON

public struct FormatContainer: Codable, Equatable, Sendable {
  public let formats: [JSON]

  enum Key: String, CodingKey {
    case formats
  }

  public init(formats: [JSON]) {
    self.formats = formats
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let dictionary = try container.decode([String: [String: [String]]].self)
    var parsed: [JSON] = []

    for (key, value) in dictionary {
      var newDict: [String: Any] = [:]
      newDict["designation"] = key
      newDict.merge(value) { (_, new) in new }
      parsed.append(JSON(newDict))
    }
    formats = parsed
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Key.self)
    try? container.encode(formats, forKey: .formats)
  }
}
