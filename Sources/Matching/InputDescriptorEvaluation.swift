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

public enum InputDescriptorEvaluation: CustomDebugStringConvertible {
  case candidateClaim(matches: [Field: CandidateField])
  case notMatchingClaim
  case notMatchedFieldConstraints
  case unsupportedFormat

  // swiftlint:disable line_length
  public var debugDescription: String {
    switch self {
    case .candidateClaim(matches: let matches):
      return "Matched \(matches.map {($0.key, $0.value)}.enumerated().map { "Field no:\($0) was matched \($1.1.debugDescription)"})\n"
    case .notMatchingClaim:
      return "Not matched"
    case .notMatchedFieldConstraints:
      return "Not matched field constraints"
    case .unsupportedFormat:
      return "Unsupported format"
    }
  }
  // swiftlint:enable line_length
}
