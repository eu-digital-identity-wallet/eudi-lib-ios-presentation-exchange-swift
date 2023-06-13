import XCTest

@testable import PresentationExchange

class ErrorTests: XCTestCase {
    
  func testErrorDescriptionFileNotFound() {
    let error = JSONParseError.fileNotFound(filename: "data.json")
    XCTAssertEqual(error.errorDescription, ".fileNotFound data.json")
  }
  
  func testErrorDescriptionDataInitialization() {
    let underlyingError = NSError(domain: "TestDomain", code: 123, userInfo: nil)
    let error = JSONParseError.dataInitialisation(underlyingError)
    XCTAssertEqual(error.errorDescription, ".dataInitialisation \(underlyingError.localizedDescription)")
  }
  
  func testErrorDescriptionJSONSerialization() {
    let underlyingError = NSError(domain: "TestDomain", code: 456, userInfo: nil)
    let error = JSONParseError.jsonSerialization(underlyingError)
    XCTAssertEqual(error.errorDescription, ".jsonSerialization \(underlyingError.localizedDescription)")
  }
  
  func testErrorDescriptionMappingFail() {
    let value = 123
    let toType = String.self
    let error = JSONParseError.mappingFail(value: value, toType: toType)
    XCTAssertEqual(error.errorDescription, ".mappingFail from: \(value) to: \(toType)")
  }
  
  func testErrorDescriptionInvalidJSON() {
    let error = JSONParseError.invalidJSON
    XCTAssertEqual(error.errorDescription, ".invalidJSON")
  }
  
  func testErrorDescriptionInvalidJWT() {
    let error = JSONParseError.invalidJWT
    XCTAssertEqual(error.errorDescription, ".invalidJWT")
  }
  
  func testErrorDescriptionNotSupportedOperation() {
    let error = JSONParseError.notSupportedOperation
    XCTAssertEqual(error.errorDescription, ".notSupportedOperation")
  }
  
  func testErrorDescriptionInvalidFormat() {
    let error = PresentationError.invalidFormat
    XCTAssertEqual(error.errorDescription, ".invalidFormat")
  }
      
  func testErrorDescriptionInvalidPresentationDefinition() {
    let error = PresentationError.invalidPresentationDefinition
    XCTAssertEqual(error.errorDescription, ".invalidPresentationDefinition")
  }
  
  func testErrorDescriptionConflictingData() {
    let error = PresentationError.conflictingData
    XCTAssertEqual(error.errorDescription, ".conflictingData")
  }
      
  func testParserErrorNotFound() {
    let error = ParserError.notFound
    XCTAssertEqual(error.errorDescription, ".notFound")
  }

  func testParserErrorInvalidData() {
    let error = ParserError.invalidData

    XCTAssertEqual(error.errorDescription, ".invalidData")
  }

  func testParserErrorDecodingFailure() {
    let failureReason = "Failed to decode"
    let error = ParserError.decodingFailure(failureReason)

    XCTAssertEqual(error.errorDescription, ".decodingFailure \(failureReason)")
  }

  func testParserErrorEquatable() {
    let error1 = ParserError.notFound
    let error2 = ParserError.notFound
    let error3 = ParserError.invalidData
    let error4 = ParserError.decodingFailure("Failed to decode")

    XCTAssertEqual(error1, error2)
    XCTAssertNotEqual(error1, error3)
    XCTAssertNotEqual(error1, error4)
  }
}
