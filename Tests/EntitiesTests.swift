import XCTest
@testable import PresentationExchange

class EntitiesTests: XCTestCase {

  func testAllGroups_NoFrom_NoFromNested_ShouldReturnEmptySet() {
    
    // Given
    let requirement = SubmissionRequirement(
      rule: .none,
      count: nil,
      min: nil,
      max: nil,
      from: nil,
      fromNested: nil,
      name: nil,
      purpose: nil
    )
    
    // When
    let allGroups = requirement.allGroups
    
    // Then
    XCTAssertTrue(allGroups.isEmpty)
  }
    
  func testAllGroups_WithFrom_ShouldReturnSetWithFromGroup() {
    // Given
    let fromGroup = Group()
    let requirement = SubmissionRequirement(
        rule: .none,
        count: nil,
        min: nil,
        max: nil,
        from: fromGroup,
        fromNested: nil,
        name: nil,
        purpose: nil
    )
    
    // When
    let allGroups = requirement.allGroups
    
    // Then
    XCTAssertEqual(allGroups, Set([fromGroup]))
  }
  
  
  func testInitDescriptorMap() {
    // Given
    let id = "123"
    let format = "json"
    let path = "/path/to/file.json"
    
    // When
    let descriptorMap = DescriptorMap(id: id, format: format, path: path)
    
    // Then
    XCTAssertEqual(descriptorMap.id, id)
    XCTAssertEqual(descriptorMap.format, format)
    XCTAssertEqual(descriptorMap.path, path)
  }
      
  func testDescriptorMapCoding() throws {
    // Given
    let id = "123"
    let format = "json"
    let path = "/path/to/file.json"
    let descriptorMap = DescriptorMap(id: id, format: format, path: path)
    
    // When
    let encoder = JSONEncoder()
    let encodedData = try encoder.encode(descriptorMap)
    
    let decoder = JSONDecoder()
    let decodedMap = try decoder.decode(DescriptorMap.self, from: encodedData)
    
    // Then
    XCTAssertEqual(decodedMap.id, id)
    XCTAssertEqual(decodedMap.format, format)
    XCTAssertEqual(decodedMap.path, path)
  }
  
  func testCandidateFieldEquatable() {
    let path = JSONPath("path.to.field")
    
    let field1 = CandidateField.requiredFieldNotFound
    let field2 = CandidateField.optionalFieldNotFound
    let field3 = CandidateField(path: path, content: "Some content")
    let field4 = CandidateField(path: path, predicateEvaluation: true)
    
    XCTAssertEqual(field1, CandidateField.requiredFieldNotFound)
    XCTAssertEqual(field2, CandidateField.optionalFieldNotFound)
    XCTAssertEqual(field3, CandidateField.found(path: path, content: "Some content"))
    XCTAssertEqual(field4, CandidateField.predicateEvaluated(path: path, predicateEvaluation: true))
    
    XCTAssertNotEqual(field1, field2)
    XCTAssertNotEqual(field2, field3)
    XCTAssertNotEqual(field3, field4)
  }
  
  func testCandidateFieldDebugDescription() {
    let path = JSONPath("path.to.field")
    
    let field1 = CandidateField.requiredFieldNotFound
    XCTAssertEqual(field1.debugDescription, "required not present")
    
    let field2 = CandidateField.optionalFieldNotFound
    XCTAssertEqual(field2.debugDescription, "not present but was optional")
    
    let field3 = CandidateField.found(path: path, content: "Some content")
    XCTAssertEqual(field3.debugDescription, "in path \(path) with content Some content")
    
    let field4 = CandidateField.predicateEvaluated(path: path, predicateEvaluation: true)
    XCTAssertEqual(field4.debugDescription, "in path \(path) predicated evaluated to true")
  }
  
  func testDebugNotMatchingClaim() {
    let evaluation = InputDescriptorEvaluation.notMatchingClaim
    
    XCTAssertEqual(evaluation.debugDescription, "Not matched")
  }
  
  func testDebugNotMatchedFieldConstraints() {
    let evaluation = InputDescriptorEvaluation.notMatchedFieldConstraints
    
    XCTAssertEqual(evaluation.debugDescription, "Not matched field constraints")
  }
  
  func testDebugUnsupportedFormat() {
    let evaluation = InputDescriptorEvaluation.unsupportedFormat
    
    XCTAssertEqual(evaluation.debugDescription, "Unsupported format")
  }
}

class AuthorizationRequestUnprocessedDataTests: XCTestCase {
    
  func testInit() {
    let data = AuthorizationRequestUnprocessedData(
        responseType: "code",
        responseUri: "https://example.com/response",
        redirectUri: "https://example.com/redirect",
        presentationDefinition: "presentationDefinition",
        presentationDefinitionUri: "https://example.com/definition",
        request: "request",
        requestUri: "https://example.com/request",
        clientMetaData: "clientMetaData",
        clientId: "clientId",
        clientMetadataUri: "https://example.com/metadata",
        clientIdScheme: "clientScheme",
        nonce: "nonce",
        scope: "scope",
        responseMode: "responseMode",
        state: "state",
        idTokenType: "idTokenType"
    )
    
    XCTAssertEqual(data.responseType, "code")
    XCTAssertEqual(data.responseUri, "https://example.com/response")
    XCTAssertEqual(data.redirectUri, "https://example.com/redirect")
    XCTAssertEqual(data.presentationDefinition, "presentationDefinition")
    XCTAssertEqual(data.presentationDefinitionUri, "https://example.com/definition")
    XCTAssertEqual(data.request, "request")
    XCTAssertEqual(data.requestUri, "https://example.com/request")
    XCTAssertEqual(data.clientMetaData, "clientMetaData")
    XCTAssertEqual(data.clientId, "clientId")
    XCTAssertEqual(data.clientMetadataUri, "https://example.com/metadata")
    XCTAssertEqual(data.clientIdScheme, "clientScheme")
    XCTAssertEqual(data.nonce, "nonce")
    XCTAssertEqual(data.scope, "scope")
    XCTAssertEqual(data.responseMode, "responseMode")
    XCTAssertEqual(data.state, "state")
    XCTAssertEqual(data.idTokenType, "idTokenType")
  }
  
  func testInitFromDecoder() throws {
    let json = """
    {
        "response_type": "code",
        "response_uri": "https://example.com/response",
        "redirect_uri": "https://example.com/redirect",
        "presentation_definition": "presentationDefinition",
        "presentation_definition_uri": "https://example.com/definition",
        "request": "request",
        "request_uri": "https://example.com/request",
        "client_meta_data": "clientMetaData",
        "client_id": "clientId",
        "client_metadata_uri": "https://example.com/metadata",
        "client_id_scheme": "clientScheme",
        "nonce": "nonce",
        "scope": "scope",
        "response_mode": "responseMode",
        "state": "state",
        "id_token_type": "idTokenType"
    }
    """
    
    let jsonData = json.data(using: .utf8)!
    let decoder = JSONDecoder()
    
    let data = try decoder.decode(AuthorizationRequestUnprocessedData.self, from: jsonData)
    
    XCTAssertEqual(data.responseType, "code")
    XCTAssertEqual(data.responseUri, "https://example.com/response")
    XCTAssertEqual(data.redirectUri, "https://example.com/redirect")
    XCTAssertEqual(data.presentationDefinition, "presentationDefinition")
    XCTAssertEqual(data.presentationDefinitionUri, "https://example.com/definition")
    XCTAssertEqual(data.request, "request")
    XCTAssertEqual(data.requestUri, "https://example.com/request")
    XCTAssertEqual(data.clientMetaData, "clientMetaData")
    XCTAssertEqual(data.clientId, "clientId")
    XCTAssertEqual(data.clientMetadataUri, "https://example.com/metadata")
    XCTAssertEqual(data.clientIdScheme, "clientScheme")
    XCTAssertEqual(data.nonce, "nonce")
    XCTAssertEqual(data.scope, "scope")
    XCTAssertEqual(data.responseMode, "responseMode")
    XCTAssertEqual(data.state, "state")
    XCTAssertEqual(data.idTokenType, "idTokenType")
  }
  
  func testInitFromURL() {
    let url = URL(string: "https://example.com?response_type=code&response_uri=https%3A%2F%2Fexample.com%2Fresponse&redirect_uri=https%3A%2F%2Fexample.com%2Fredirect&presentation_definition=presentationDefinition&presentation_definition_uri=https%3A%2F%2Fexample.com%2Fdefinition&request=request&request_uri=https%3A%2F%2Fexample.com%2Frequest&client_meta_data=clientMetaData&client_id=clientId&client_metadata_uri=https%3A%2F%2Fexample.com%2Fmetadata&client_id_scheme=clientScheme&nonce=nonce&scope=scope&response_mode=responseMode&state=state&id_token_type=idTokenType")!
    
    let data = AuthorizationRequestUnprocessedData(from: url)
    
    XCTAssertEqual(data?.responseType, "code")
    XCTAssertEqual(data?.responseUri, "https://example.com/response")
    XCTAssertEqual(data?.redirectUri, "https://example.com/redirect")
    XCTAssertEqual(data?.presentationDefinition, "presentationDefinition")
    XCTAssertEqual(data?.presentationDefinitionUri, "https://example.com/definition")
    XCTAssertEqual(data?.request, "request")
    XCTAssertEqual(data?.requestUri, "https://example.com/request")
    XCTAssertEqual(data?.clientMetaData, "clientMetaData")
    XCTAssertEqual(data?.clientId, "clientId")
    XCTAssertEqual(data?.clientMetadataUri, "https://example.com/metadata")
    XCTAssertEqual(data?.clientIdScheme, "clientScheme")
    XCTAssertEqual(data?.nonce, "nonce")
    XCTAssertEqual(data?.scope, "scope")
    XCTAssertEqual(data?.responseMode, "responseMode")
    XCTAssertEqual(data?.state, "state")
    XCTAssertEqual(data?.idTokenType, "idTokenType")
  }
}


final class PresentationDefinitionSourceTests: XCTestCase {
    
  func testInitFromAuthorizationRequestObjectWithPresentationDefinitionUri() throws {
    let authorizationRequestObject: JSONObject = [
        "presentation_definition_uri": "https://example.com/presentation-definition"
    ]
    
    let source = try PresentationDefinitionSource(authorizationRequestObject: authorizationRequestObject)
    
    guard case .fetchByReference(let url) = source else {
        XCTFail("Expected .fetchByReference case")
        return
    }
    
    XCTAssertEqual(url.absoluteString, "https://example.com/presentation-definition")
  }
  
  func testInitFromAuthorizationRequestObjectWithScope() throws {
    let authorizationRequestObject: JSONObject = [
        "scope": "openid email profile"
    ]
    
    let source = try PresentationDefinitionSource(authorizationRequestObject: authorizationRequestObject)
    
    guard case .implied(let scope) = source else {
      XCTFail("Expected .implied case")
      return
    }
    
    XCTAssertEqual(scope, ["openid", "email", "profile"])
  }
  
  func testInitFromAuthorizationRequestObjectWithInvalidPresentationDefinition() {
    let authorizationRequestObject: JSONObject = [:]
    
    XCTAssertThrowsError(try PresentationDefinitionSource(authorizationRequestObject: authorizationRequestObject)) { error in
      XCTAssertEqual(error as? PresentationError, PresentationError.invalidPresentationDefinition)
    }
  }
  
  func testInitFromAuthorizationRequestDataWithPresentationDefinitionUri() throws {
    let authorizationRequestData = AuthorizationRequestUnprocessedData(presentationDefinitionUri: "https://example.com/presentation-definition")
    
    let source = try PresentationDefinitionSource(authorizationRequestData: authorizationRequestData)
    
    guard case .fetchByReference(let url) = source else {
      XCTFail("Expected .fetchByReference case")
      return
    }
    
    XCTAssertEqual(url.absoluteString, "https://example.com/presentation-definition")
  }
  
  func testInitFromAuthorizationRequestDataWithScope() throws {
    let authorizationRequestData = AuthorizationRequestUnprocessedData(scope: "openid email profile")
    
    let source = try PresentationDefinitionSource(authorizationRequestData: authorizationRequestData)
    
    guard case .implied(let scope) = source else {
      XCTFail("Expected .implied case")
      return
    }
    
    XCTAssertEqual(scope, ["openid", "email", "profile"])
  }
  
  func testInitFromAuthorizationRequestDataWithInvalidPresentationDefinition() {
    let authorizationRequestData = AuthorizationRequestUnprocessedData()
    
    XCTAssertThrowsError(try PresentationDefinitionSource(authorizationRequestData: authorizationRequestData)) { error in
      XCTAssertEqual(error as? PresentationError, PresentationError.invalidPresentationDefinition)
    }
  }
}

final class SubmissionRequirementTests: XCTestCase {

  func testAllGroups_NoGroups_ReturnsEmptySet() {
    let submissionRequirement = SubmissionRequirement(
        rule: .all,
        count: nil,
        min: nil,
        max: nil,
        from: nil,
        fromNested: nil,
        name: nil,
        purpose: nil
    )
    
    let allGroups = submissionRequirement.allGroups
    
    XCTAssertTrue(allGroups.isEmpty)
  }
  
  func testAllGroups_OneGroup_ReturnsSetWithOneGroup() {
    let group = Group("group")
    let submissionRequirement = SubmissionRequirement(
        rule: .all,
        count: nil,
        min: nil,
        max: nil,
        from: group,
        fromNested: nil,
        name: nil,
        purpose: nil
    )
    
    let allGroups = submissionRequirement.allGroups
    
    XCTAssertEqual(allGroups, Set([group]))
  }
  
  func testAllGroups_NestedGroups_ReturnsSetWithAllNestedGroups() {
    let group1 = Group("group1")
    let group2 = Group("group2")
    let nested1 = SubmissionRequirement(
        rule: .all,
        count: nil,
        min: nil,
        max: nil,
        from: group1,
        fromNested: nil,
        name: nil,
        purpose: nil
    )
    let nested2 = SubmissionRequirement(
        rule: .all,
        count: nil,
        min: nil,
        max: nil,
        from: group2,
        fromNested: nil,
        name: nil,
        purpose: nil
    )
    let submissionRequirement = SubmissionRequirement(
        rule: .all,
        count: nil,
        min: nil,
        max: nil,
        from: nil,
        fromNested: [nested1, nested2],
        name: nil,
        purpose: nil
    )
    
    let allGroups = submissionRequirement.allGroups
    
    XCTAssertEqual(allGroups, Set([group1, group2]))
  }
  
  func testInitFromDecoder_ValidData() {
    let jsonData = """
    {
        "rule": "all",
        "count": 5,
        "min": 2,
        "max": 10,
        "from": "group",
        "from_nested": null,
        "name": "requirement",
        "purpose": "purpose"
    }
    """.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    
    XCTAssertNoThrow(try decoder.decode(SubmissionRequirement.self, from: jsonData))
  }
  
  func testInitFromDecoder_ConflictingData() {
    let jsonData = """
    {
        "rule": "all",
        "count": 5,
        "min": 2,
        "max": 10,
        "from": "group",
        "from_nested": [],
        "name": "requirement",
        "purpose": "purpose"
    }
    """.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    
    XCTAssertThrowsError(try decoder.decode(SubmissionRequirement.self, from: jsonData)) { error in
        XCTAssertEqual(error as? PresentationError, .conflictingData)
    }
  }
  
  func testEncode() {
    let submissionRequirement = SubmissionRequirement(
        rule: .all,
        count: 5,
        min: 2,
        max: 10,
        from: Group("group"),
        fromNested: nil,
        name: "requirement",
        purpose: "purpose"
    )
    
    let encoder = JSONEncoder()
    
    XCTAssertNoThrow(try encoder.encode(submissionRequirement))
  }
}


final class StringExtensionsTests: XCTestCase {

  func testIsValidDate_ValidDateFormat_ReturnsTrue() {
    let validDate = "2023-06-06"
    XCTAssertTrue(validDate.isValidDate())
  }
  
  func testIsValidDate_InvalidDateFormat_ReturnsFalse() {
    let invalidDate = "06-06-2023"
    XCTAssertFalse(invalidDate.isValidDate())
  }
  
  func testIsValidJWT_ValidJWT_ReturnsTrue() {
    let validJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
    XCTAssertTrue(validJWT.isValidJWT())
  }
  
  func testIsValidJWT_InvalidJWT_ReturnsFalse() {
    let invalidJWT = "invalid.jwt"
    XCTAssertFalse(invalidJWT.isValidJWT())
  }
  
  func testConvertToDictionary_ValidJSONString_ReturnsDictionary() {
    let validJSONString = """
    {
        "key": "value"
    }
    """
    
    XCTAssertNoThrow(try validJSONString.convertToDictionary())
  }
  
  func testConvertToDictionary_InvalidJSONString_ReturnsNil() {
    let invalidJSONString = "invalid json"
    
    XCTAssertThrowsError(try invalidJSONString.convertToDictionary())
  }
  
  func testIsValidJSONPath_ValidJSONPath_ReturnsTrue() {
    let validJSONPath = "$.key"
    XCTAssertTrue(validJSONPath.isValidJSONPath)
  }
  
  func testIsValidJSONPath_InvalidJSONPath_ReturnsFalse() {
    let invalidJSONPath = "invalid.path"
    XCTAssertFalse(invalidJSONPath.isValidJSONPath)
  }
  
  func testIsValidJSONString_ValidJSONString_ReturnsTrue() {
    let validJSONString = """
    {
        "key": "value"
    }
    """
    XCTAssertTrue(validJSONString.isValidJSONString)
  }
  
  func testIsValidJSONString_InvalidJSONString_ReturnsFalse() {
    let invalidJSONString = "invalid json"
    XCTAssertFalse(invalidJSONString.isValidJSONString)
  }
}


class ParserTests: XCTestCase {
  
  struct TestModel: Codable {
    let name: String
  }
  
  func testDecodeFromStringSuccess() {
    let json = """
    {
      "name": "John"
    }
    """
    
    let parser = Parser()
    let result: Result<TestModel, ParserError> = parser.decode(json: json)
    
    switch result {
    case .success(let model):
      XCTAssertEqual(model.name, "John")
    case .failure(let error):
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testDecodeFromStringFailure() {
    let json = """
    {
      "name1": "John",
      "age": 30
    }
    """
    
    let parser = Parser()
    let result: Result<TestModel, ParserError> = parser.decode(json: json)
    
    switch result {
    case .success:
      XCTFail("Expected decoding failure")
    case .failure:
      XCTAssertTrue(true)
    }
  }
  
  func testDecodeFromFileSuccess() {
    let json = """
    {
      "name": "John",
      "age": 30
    }
    """
    
    let parser = Parser()
    let result: Result<TestModel, ParserError> = parser.decode(json: json)
    
    
    switch result {
    case .success(let model):
      XCTAssertEqual(model.name, "John")
    case .failure(let error):
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testDecodeFromFileFailure() {
    let parser = Parser()
    let result: Result<TestModel, ParserError> = parser.decode(path: "InvalidPath", type: "json")
    
    switch result {
    case .success:
      XCTFail("Expected decoding failure")
    case .failure(let error):
      XCTAssertEqual(error, .notFound)
    }
  }
}


class PresentationDefinitionTests: XCTestCase {

  func testPresentationDefinitionContainer() {
    let comment = "This is a presentation definition"
    let definition = PresentationDefinition(
      id: "123",
      name: "John",
      purpose: "Verify identity",
      formatContainer: .init(formats: []),
      inputDescriptors: [.init(id: "", name: "", purpose: "", formatContainer: nil, constraints: .init(fields: []), groups: nil)],
      submissionRequirements: []
    )

    let container = PresentationDefinitionContainer(comment: comment, definition: definition)

    XCTAssertEqual(container.comment, comment)
    XCTAssertEqual(container.definition.id, "123")
    XCTAssertEqual(container.definition.name, "John")
    XCTAssertEqual(container.definition.purpose, "Verify identity")
    XCTAssertEqual(container.definition.inputDescriptors.count, 1)
    XCTAssertEqual(container.definition.submissionRequirements?.count, 0)
  }

  func testPresentationDefinitionInitialization() {
    let presentationDefinition = PresentationDefinition(
      id: "123",
      name: "John",
      purpose: "Verify identity",
      formatContainer: .init(formats: []),
      inputDescriptors: [.init(id: "", name: "", purpose: "", formatContainer: nil, constraints: .init(fields: []), groups: nil)],
      submissionRequirements: []
    )
    
    XCTAssertEqual(presentationDefinition.id, "123")
    XCTAssertEqual(presentationDefinition.name, "John")
    XCTAssertEqual(presentationDefinition.purpose, "Verify identity")
    XCTAssertEqual(presentationDefinition.inputDescriptors.count, 1)
    XCTAssertEqual(presentationDefinition.submissionRequirements?.count, 0)
  }
}


class VpTokenTests: XCTestCase {

  func testVpTokenContainer() {
    let presentationDefinition = PresentationDefinition(
      id: "123",
      name: "John",
      purpose: "Verify identity",
      formatContainer: .init(formats: []),
      inputDescriptors: [.init(id: "", name: "", purpose: "", formatContainer: nil, constraints: .init(fields: []), groups: nil)],
      submissionRequirements: []
    )

    let vpToken = VpToken(presentationDefinition: presentationDefinition)
    let container = VpTokenContainer(vpToken: vpToken)

    XCTAssertEqual(container.vpToken.presentationDefinition.id, "123")
    XCTAssertEqual(container.vpToken.presentationDefinition.name, "John")
    XCTAssertEqual(container.vpToken.presentationDefinition.purpose, "Verify identity")
    XCTAssertEqual(container.vpToken.presentationDefinition.inputDescriptors.count, 1)
    XCTAssertEqual(container.vpToken.presentationDefinition.submissionRequirements?.count, 0)
  }

  func testVpTokenInitialization() {
    let presentationDefinition = PresentationDefinition(
      id: "123",
      name: "John",
      purpose: "Verify identity",
      formatContainer: .init(formats: []),
      inputDescriptors: [.init(id: "", name: "", purpose: "", formatContainer: nil, constraints: .init(fields: []), groups: nil)],
      submissionRequirements: []
    )

    let vpToken = VpToken(presentationDefinition: presentationDefinition)

    XCTAssertEqual(vpToken.presentationDefinition.id, "123")
    XCTAssertEqual(vpToken.presentationDefinition.name, "John")
    XCTAssertEqual(vpToken.presentationDefinition.purpose, "Verify identity")
    XCTAssertEqual(vpToken.presentationDefinition.inputDescriptors.count, 1)
    XCTAssertEqual(vpToken.presentationDefinition.submissionRequirements?.count, 0)
  }
}


class PresentationSubmissionTests: XCTestCase {

  func testPresentationSubmissionContainer() {
    let descriptorMap1 = DescriptorMap(id: "descriptor1", format: "", path: "path1")
    let descriptorMap2 = DescriptorMap(id: "descriptor2", format: "", path: "path2")

    let presentationSubmission = PresentationSubmission(
      id: "123",
      definitionID: "456",
      descriptorMap: [descriptorMap1, descriptorMap2]
    )

    let container = PresentationSubmissionContainer(submission: presentationSubmission)

    XCTAssertEqual(container.submission.id, "123")
    XCTAssertEqual(container.submission.definitionID, "456")
    XCTAssertEqual(container.submission.descriptorMap.count, 2)
    XCTAssertEqual(container.submission.descriptorMap[0].id, "descriptor1")
    XCTAssertEqual(container.submission.descriptorMap[0].path, "path1")
    XCTAssertEqual(container.submission.descriptorMap[1].id, "descriptor2")
    XCTAssertEqual(container.submission.descriptorMap[1].path, "path2")
  }

  func testPresentationSubmissionInitialization() {
    let descriptorMap1 = DescriptorMap(id: "descriptor1", format: "", path: "path1")
    let descriptorMap2 = DescriptorMap(id: "descriptor2", format: "", path: "path2")

    let presentationSubmission = PresentationSubmission(
      id: "123",
      definitionID: "456",
      descriptorMap: [descriptorMap1, descriptorMap2]
    )

    XCTAssertEqual(presentationSubmission.id, "123")
    XCTAssertEqual(presentationSubmission.definitionID, "456")
    XCTAssertEqual(presentationSubmission.descriptorMap.count, 2)
    XCTAssertEqual(presentationSubmission.descriptorMap[0].id, "descriptor1")
    XCTAssertEqual(presentationSubmission.descriptorMap[0].path, "path1")
    XCTAssertEqual(presentationSubmission.descriptorMap[1].id, "descriptor2")
    XCTAssertEqual(presentationSubmission.descriptorMap[1].path, "path2")
  }
}
