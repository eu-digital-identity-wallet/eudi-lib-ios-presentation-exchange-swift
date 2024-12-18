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

public enum CandidateField: Equatable, CustomDebugStringConvertible {
  case requiredFieldNotFound
  case optionalFieldNotFound
  case found(path: JSONPath, content: JSON)
  case predicateEvaluated(path: JSONPath, predicateEvaluation: Bool)

  public init(path: JSONPath, content: JSON) {
    self = .found(path: path, content: content)
  }

  public init(path: JSONPath, predicateEvaluation: Bool) {
    self = .predicateEvaluated(path: path, predicateEvaluation: predicateEvaluation)
  }

  public var debugDescription: String {
    switch self {
    case .requiredFieldNotFound:
      return "required not present"
    case .optionalFieldNotFound:
      return "not present but was optional"
    case .found(let path, let content):
      return "in path \(path) with content \(content)"
    case .predicateEvaluated(let path, let predicateEvaluation):
      return "in path \(path) predicated evaluated to \(predicateEvaluation)"
    }
  }
}
