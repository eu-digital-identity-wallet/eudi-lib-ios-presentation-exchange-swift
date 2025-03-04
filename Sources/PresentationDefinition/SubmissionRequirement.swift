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

public struct SubmissionRequirement: Codable, Sendable {
  public let rule: Rule
  public let count: Int?
  public let min: Int?
  public let max: Int?
  public let from: Group?
  public let fromNested: [SubmissionRequirement]?
  public let name: Name?
  public let purpose: Purpose?

  enum CodingKeys: String, CodingKey {
    case rule
    case count
    case min
    case max
    case from
    case name
    case purpose
    case fromNested = "from_nested"
  }

  var allGroups: Set<Group> {
    if let from = from {
      return Set([from])
    } else if let fromNested = fromNested {
      let nested = fromNested.flatMap { requirement in
        return requirement.allGroups
      }
      return Set(nested)
    }
    return []
  }

  init(
    rule: Rule,
    count: Int?,
    min: Int?,
    max: Int?,
    from: Group?,
    fromNested: [SubmissionRequirement]?,
    name: Name?,
    purpose: Purpose?
  ) {
    self.rule = rule
    self.count = count
    self.min = min
    self.max = max
    self.from = from
    self.fromNested = fromNested
    self.name = name
    self.purpose = purpose
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    rule = try container.decode(Rule.self, forKey: .rule)
    count = try? container.decode(Int.self, forKey: .count)
    min = try? container.decode(Int.self, forKey: .min)

    max = try? container.decode(Int.self, forKey: .max)
    from = try? container.decode(String.self, forKey: .from)
    fromNested = try? container.decode([SubmissionRequirement].self, forKey: .fromNested)

    name = try? container.decode(String.self, forKey: .name)
    purpose = try? container.decode(String.self, forKey: .purpose)

    if from != nil && fromNested != nil {
      throw PresentationError.conflictingData
    }

    if from == nil && fromNested == nil {
      throw PresentationError.conflictingData
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try? container.encode(rule, forKey: .rule)
    try? container.encode(count, forKey: .count)
    try? container.encode(min, forKey: .min)

    try? container.encode(max, forKey: .max)
    try? container.encode(from, forKey: .from)
    try? container.encode(fromNested, forKey: .fromNested)

    try? container.encode(name, forKey: .name)
    try? container.encode(purpose, forKey: .purpose)
  }
}
