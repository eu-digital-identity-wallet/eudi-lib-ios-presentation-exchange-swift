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
import Sextant
import JSONSchema
import SwiftyJSON

public typealias ClaimsEvaluation = [ClaimId: [InputDescriptorId: InputDescriptorEvaluation]]
public typealias InputDescriptorEvaluationPerClaim = [InputDescriptorId: [ClaimId: InputDescriptorEvaluation]]

private protocol EvaluatorType {
  func evaluate(
    definition: PresentationDefinition,
    candidateClaims: InputDescriptorEvaluationPerClaim,
    notMatchingClaims: InputDescriptorEvaluationPerClaim
  ) -> Match
}

public protocol PresentationMatcherType {
  func match(claims: [Claim], with definition: PresentationDefinition) -> Match
}

public class PresentationMatcher: PresentationMatcherType {
  public init() { }
  public func match(claims: [Claim], with definition: PresentationDefinition) -> Match {
    let claimsEvaluation = claims.associate {
      (
        $0.id,
        matchInputDescriptors(
          presentationDefinitionFormat: definition.formatContainer?.formats,
          inputDescriptors: definition.inputDescriptors,
          claim: $0
        )
      )
    }

    let (candidateClaims, notMatchingClaims) = splitPerDescriptor(
      presentationDefinition: definition,
      claimsEvaluation: claimsEvaluation
    )

    return evaluate(
      definition: definition,
      candidateClaims: candidateClaims,
      notMatchingClaims: notMatchingClaims
    )
  }
}

private extension PresentationMatcher {
  private func matchInputDescriptors(
    presentationDefinitionFormat: [JSON]?,
    inputDescriptors: [InputDescriptor],
    claim: Claim
  ) -> [InputDescriptorId: InputDescriptorEvaluation] {
    inputDescriptors.associate {
      (
        $0.id,
        evaluate(
          presentationDefinitionFormat: presentationDefinitionFormat,
          inputDescriptor: $0,
          claim: claim
        )
      )
    }
  }

  private func evaluate(
    presentationDefinitionFormat: [JSON]?,
    inputDescriptor: InputDescriptor,
    claim: Claim
  ) -> InputDescriptorEvaluation {
    let supportedFormat = isFormatSupported(
      inputDescriptor: inputDescriptor,
      presentationDefinitionFormat: presentationDefinitionFormat,
      claimFormat: claim.format
    )

    return !supportedFormat
    ? .unsupportedFormat
    : checkFieldConstraints(
      fieldConstraints: inputDescriptor.constraints.fields,
      claim: claim
    )
  }

  private func isFormatSupported(
    inputDescriptor: InputDescriptor,
    presentationDefinitionFormat: [JSON]?,
    claimFormat: String
  ) -> Bool {

    guard let formats: [JSON] = inputDescriptor.formatContainer?.formats ?? presentationDefinitionFormat else {
      return true
    }

    return formats.compactMap { $0["designation"].string }.contains(where: { $0 == claimFormat })
  }

  private func checkFieldConstraints(
    fieldConstraints: [Field],
    claim: Claim
  ) -> InputDescriptorEvaluation {

    let matchedResults: [Field: CandidateField] =
    fieldConstraints.associateWith { field in
      matchClaim(claim: claim, with: field)
    }

    let notMatchedResults = matchedResults.filterValues {
      $0 == .requiredFieldNotFound
    }.keys

    return !notMatchedResults.isEmpty
    ? .notMatchedFieldConstraints
    : .candidateClaim(matches: matchedResults)
  }

  private func matchClaim(
    claim: Claim,
    with field: Field
  ) -> CandidateField {
    for path in field.paths {
      let json = try? claim.jsonObject.toJSONString()
      if let values = json?.query(values: path)?.compactMap({ $0 }),
         let value = values.first as? String,
         filter(
          value: value,
          with: field.filter
         ) {
        return .found(path: path, content: value)
      }
    }
    return field.optional == true ? .optionalFieldNotFound : .requiredFieldNotFound
  }

  private func filter(
    value: String,
    with filter: Filter?
  ) -> Bool {
    guard let filter = filter else {
      return true
    }

    // Note: the JSONSchema validation library does not support
    // date validation as of 0.6.0
    if let date = filter["format"].string, date == "date" {
      return value.isValidDate()
    }

    do {
      let result = try JSONSchema.validate(
        value,
        schema: filter.dictionaryObject ?? [:]
      )
      return result.valid

    } catch {
      return false
    }
  }

  private func splitPerDescriptor(
    presentationDefinition: PresentationDefinition,
    claimsEvaluation: ClaimsEvaluation
  ) -> (
    candidateClaims: InputDescriptorEvaluationPerClaim,
    notMatchingClaims: InputDescriptorEvaluationPerClaim
  ) {

    var candidateClaimsPerDescriptor: [InputDescriptorId: [ClaimId: InputDescriptorEvaluation]] = [:]
    var notMatchingClaimsPerDescriptor: [InputDescriptorId: [ClaimId: InputDescriptorEvaluation]] = [:]

    func updateCandidateClaims(inputDescriptor: InputDescriptor) {
      let candidateClaims = claimsEvaluation.mapValues {
        $0[inputDescriptor.id]
      }.filter {
        guard let value = $0.value else {
          return false
        }
        switch value {
        case .candidateClaim:
          return true
        default: return false
        }
      }
      .compactMapValues { $0 }

      if !candidateClaims.isEmpty {
        candidateClaimsPerDescriptor[inputDescriptor.id] = candidateClaims
      }
    }

    func updateNotMatchingClaims(inputDescriptor: InputDescriptor) {
      let candidateClaims = claimsEvaluation.mapValues {
        $0[inputDescriptor.id]
      }.filter {
        guard let value = $0.value else {
          return false
        }
        switch value {
        case .notMatchedFieldConstraints:
          return true
        default: return false
        }
      }
      .compactMapValues { $0 }

      if !candidateClaims.isEmpty {
        notMatchingClaimsPerDescriptor[inputDescriptor.id] = candidateClaims
      }
    }

    for inputDescriptor in presentationDefinition.inputDescriptors {
      updateCandidateClaims(inputDescriptor: inputDescriptor)
      updateNotMatchingClaims(inputDescriptor: inputDescriptor)
    }

    return (candidateClaimsPerDescriptor, notMatchingClaimsPerDescriptor)
  }
}

extension PresentationMatcher: EvaluatorType {
  func evaluate(
    definition: PresentationDefinition,
    candidateClaims: InputDescriptorEvaluationPerClaim,
    notMatchingClaims: InputDescriptorEvaluationPerClaim
  ) -> Match {
    if definition.submissionRequirements != nil {
      return .notMatched(details: [:])

    } else {
      if candidateClaims.count == definition.inputDescriptors.count {
        return .matched(matches: candidateClaims)
      } else {
        return .notMatched(details: notMatchingClaims)
      }
    }
  }

  private func inputDescriptorsOf(
    definition: PresentationDefinition,
    submissionRequirement: SubmissionRequirement
  ) -> [InputDescriptor] {
    let allGroups = submissionRequirement.allGroups
    return definition.inputDescriptors.filter { inputDescriptor in
      inputDescriptor.groups?.allSatisfy { allGroups.contains($0) } ?? false
    }
  }

  func matchSubmissionRequirement(
    definition: PresentationDefinition,
    submissionRequirement: SubmissionRequirement
  ) -> Bool {
    let inputDescriptors = inputDescriptorsOf(definition: definition, submissionRequirement: submissionRequirement)
    if let from = submissionRequirement.from {
      switch from {
      case Rule.all.rawValue: break
      case Rule.pick.rawValue: break
      default: return false
      }
    } else if let fromNested = submissionRequirement.fromNested {
      return fromNested.allSatisfy { _ in
        matchSubmissionRequirement(
          definition: definition,
          submissionRequirement: submissionRequirement
        )
      }
    }
    return false
  }
}
