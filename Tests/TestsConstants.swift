import Foundation
@testable import PresentationExchange

struct TestsConstants {
  
  // MARK: - Claims
  
  static let testClaimsBankAndPassport = [
    Claim(
      id: "samplePassport",
      format: .ldp,
      jsonObject: [
        "credentialSchema":
          [
            "id": "hub://did:foo:123/Collections/schema.us.gov/passport.json"
          ],
        "credentialSubject":
          [
            "birth_date":"1974-11-11",
          ]
        ]
      ),
    Claim(
      id: "sampleBankAccount",
      format: .jwt,
      jsonObject: [
        "issuer": "did:example:123",
        "credentialSchema":
          [
            "id": "https://bank-standards.example.com/fullaccountroute.json"
          ]
        ]
      )
  ]
}
