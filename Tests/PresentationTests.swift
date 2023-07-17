import XCTest
import JSONSchema

@testable import PresentationExchange

final class PresentationTests: XCTestCase {
  
  // MARK: - Presentation definition
  
  func testPreviewPresentationDefinitionDecoding() throws {
    
    let definition = Constants.presentationDefinitionPreview()
    XCTAssert(definition.id == "32f54163-7166-48f1-93d8-ff217bdb0653")
  }
  
  func testPresentationDefinitionDecoding() throws {
    
    let parser = Parser()
    let result: Result<PresentationDefinitionContainer, ParserError> = parser.decode(
      path: "input_descriptors_example",
      type: "json"
    )
    
    let container = try? result.get()
    guard
      let container = container
    else {
      XCTAssert(false)
      return
    }
    
    XCTAssert(container.definition.id == "32f54163-7166-48f1-93d8-ff217bdb0653")
    XCTAssert(true)
  }
  
  func testPresentationDefinitionJsonStringDecoding() throws {
    
    let definition = try! Dictionary.from(
      localJSONfile: "minimal_example"
    ).get().toJSONString()!
    
    let result: Result<PresentationDefinitionContainer, ParserError> = Parser().decode(json: definition)
    
    let container = try! result.get()
    
    XCTAssert(container.definition.id == "8e6ad256-bd03-4361-a742-377e8cccced0")
  }
  
  func testValidatePresentationDefinitionAgainstSchema() throws {
    
    let schema = try! Dictionary.from(
      localJSONfile: "presentation-definition-envelope"
    ).get()
    
    let parser = Parser()
    let result: Result<PresentationDefinitionContainer, ParserError> = parser.decode(
      path: "input_descriptors_example",
      type: "json"
    )
    
    let container = try! result.get()
    let definition = try! DictionaryEncoder().encode(container.definition)
    
    let errors = try! validate(
      definition,
      schema: schema
    ).errors
    
    XCTAssertNil(errors)
  }
  
  func testValidateMdlExamplePresentationDefinitionAgainstSchema() throws {
    
    let schema = try! Dictionary.from(
      localJSONfile: "presentation-definition-envelope"
    ).get()
    
    let parser = Parser()
    let result: Result<PresentationDefinition, ParserError> = parser.decode(
      path: "mdl_example",
      type: "json"
    )
    
    let container = try! result.get()
    let definition = try! DictionaryEncoder().encode(container)
    
    let errors = try! validate(
      definition,
      schema: schema
    ).errors
    
    XCTAssertNil(errors)
  }
  
  func testValidateMdlExamplePresentationDefinitionExpectedData() throws {
    
    let parser = Parser()
    let result: Result<PresentationDefinition, ParserError> = parser.decode(
      path: "mdl_example",
      type: "json"
    )
    
    let presentationDefinition = try! result.get()
    let format = presentationDefinition.inputDescriptors.first!.formatContainer!.formats.first
    
    XCTAssertTrue(format!.designation == .msoMdoc)
  }
  
  func testValidateFormatExamplePresentationDefinitionExpectedData() throws {
    
    let parser = Parser()
    let result: Result<PresentationDefinitionContainer, ParserError> = parser.decode(
      path: "format_example",
      type: "json"
    )
    
    let presentationDefinition = try! result.get().definition

    let formats = presentationDefinition.formatContainer!.formats
    
    XCTAssert(!formats.filter { $0.designation == .jwt}.isEmpty)
  }
  
  func testAuthorizationRequestDataGivenValidInput() throws {
    
    let parser = Parser()
    let authorizationResult: Result<AuthorisationRequestObject, ParserError> = parser.decode(
      path: "valid_authorizaton_data_example",
      type: "json"
    )
    
    let authorization = try? authorizationResult.get()
    guard
      let authorization = authorization
    else {
      XCTAssert(false)
      return
    }
    
    let definitionContainerResult: Result<PresentationDefinitionContainer, ParserError> = parser.decode(json: authorization.presentationDefinition!)
    let definitionContainer = try? definitionContainerResult.get()
    guard
      let definitionContainer = definitionContainer
    else {
      XCTAssert(false)
      return
    }
    
    XCTAssert(definitionContainer.definition.inputDescriptors.count == 1)
  }
  
  func testValidateFiExamplePresentationDefinitionExpectedData() throws {
    
    let parser = Parser()
    let result: Result<PresentationDefinition, ParserError> = parser.decode(
      path: "fi",
      type: "json"
    )
    
    let presentationDefinition = try! result.get()
    let format = presentationDefinition.formatContainer!.formats.filter { $0.designation == .sdJwt}.first
    
    XCTAssertTrue(format!.designation == .sdJwt)
  }
}
