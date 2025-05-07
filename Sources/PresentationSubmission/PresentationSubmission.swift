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

/**
 Based on https://identity.foundation/presentation-exchange/
 */
public struct PresentationSubmissionContainer: Codable, Sendable {
  public let submission: PresentationSubmission

  enum CodingKeys: String, CodingKey {
    case submission = "presentation_submission"
  }

  public init(
    submission: PresentationSubmission
  ) {
    self.submission = submission
  }
}

public struct PresentationSubmission: Codable, Sendable {
  public let id: String
  public let definitionID: String
  public let descriptorMap: [DescriptorMap]

  enum CodingKeys: String, CodingKey {
    case id
    case definitionID = "definition_id"
    case descriptorMap = "descriptor_map"
  }

  public init(
    id: String,
    definitionID: String,
    descriptorMap: [DescriptorMap]
  ) {
    self.id = id
    self.definitionID = definitionID
    self.descriptorMap = descriptorMap
  }
}
