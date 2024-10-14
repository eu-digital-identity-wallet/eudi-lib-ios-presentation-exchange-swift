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
import SwiftyJSON

public struct Field: Codable, Hashable {
  public let paths: [String]
  public let filter: JSON?
  public let purpose: String?
  public let intentToRetain: Bool?
  public let optional: Bool?

  enum CodingKeys: String, CodingKey {
    case path = "path"
    case filter, purpose, optional
    case intentToRetain = "intent_to_retain"
  }

  public init(
    paths: [String],
    filter: JSON?,
    purpose: String?,
    intentToRetain: Bool?,
    optional: Bool?) {
      self.paths = paths
      self.filter = filter
      self.purpose = purpose
      self.intentToRetain = intentToRetain
      self.optional = optional
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    paths = try container.decode([String].self, forKey: .path)
    filter = try? container.decode(JSON.self, forKey: .filter)
    purpose = try? container.decode(String.self, forKey: .purpose)
    intentToRetain = try? container.decode(Bool.self, forKey: .intentToRetain)
    optional = try? container.decode(Bool.self, forKey: .optional)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try? container.encode(paths, forKey: .path)
    try? container.encode(filter, forKey: .filter)
    try? container.encode(purpose, forKey: .purpose)
    try? container.encode(intentToRetain, forKey: .intentToRetain)
    try? container.encode(optional, forKey: .optional)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(paths)
    if let filter = filter {
      for (key, _) in filter {
        hasher.combine(key)
      }
    }
    hasher.combine(purpose)
    hasher.combine(intentToRetain)
  }

  public static func == (lhs: Field, rhs: Field) -> Bool {
    return lhs.paths == rhs.paths &&
           lhs.purpose == rhs.purpose &&
           lhs.intentToRetain == rhs.intentToRetain &&
           lhs.filter ?? JSON() == rhs.filter ?? JSON()
  }
}
