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

public struct InputDescriptor: Codable {
  public let id: InputDescriptorId
  public let name: Name?
  public let purpose: Purpose?
  public let formatContainer: FormatContainer?
  public let constraints: Constraints
  public let groups: [Group]?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case purpose
    case formatContainer = "format"
    case constraints
    case groups = "group"
  }
  
  init(
    id: InputDescriptorId,
    name: Name?, purpose: Purpose?,
    formatContainer: FormatContainer?,
    constraints: Constraints,
    groups: [Group]?
  ) {
    self.id = id
    self.name = name
    self.purpose = purpose
    self.formatContainer = formatContainer
    self.constraints = constraints
    self.groups = groups
  }
}
