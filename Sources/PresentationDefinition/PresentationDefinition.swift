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

/*
 Based on https://identity.foundation/presentation-exchange/
 */
public struct PresentationDefinitionContainer: Codable, Sendable {
  public  let comment: String?
  public let definition: PresentationDefinition

  enum CodingKeys: String, CodingKey {
    case comment
    case definition = "presentation_definition"
  }

  public init(
    comment: String,
    definition: PresentationDefinition
  ) {
    self.comment = comment
    self.definition = definition
  }
}

public struct PresentationDefinition: Codable, Sendable {

  public let id: String
  public let name: Name?
  public let purpose: Purpose?
  public let formatContainer: FormatContainer?
  public let inputDescriptors: [InputDescriptor]
  public let submissionRequirements: [SubmissionRequirement]?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case purpose
    case formatContainer = "format"
    case inputDescriptors = "input_descriptors"
    case submissionRequirements = "submission_requirements"
  }

  public init(
    id: String,
    name: Name? = nil,
    purpose: Purpose? = nil,
    formatContainer: FormatContainer? = nil,
    inputDescriptors: [InputDescriptor],
    submissionRequirements: [SubmissionRequirement]? = nil) {
      self.id = id
      self.name = name
      self.purpose = purpose
      self.formatContainer = formatContainer
      self.inputDescriptors = inputDescriptors
      self.submissionRequirements = submissionRequirements
  }
}
