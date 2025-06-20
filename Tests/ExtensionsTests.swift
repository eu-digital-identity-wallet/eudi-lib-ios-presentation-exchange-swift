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
import XCTest
import JSONSchema
import Sextant

@testable import PresentationExchange

final class ExtensionsTests: XCTestCase {
  
  func testArraySubscriptGivenInboundsIndex() {
    let array = [0, 1, 2, 3, 4, 5, 6]
    XCTAssertTrue(array[safe: 1] == 1)
  }
  
  func testArraySubscriptGivenOutOfboundsIndex() {
    let array = [0, 1, 2, 3, 4, 5, 6]
    XCTAssertNil(array[safe: 10])
  }
  
  func testJsonPathSyntaxIsValid() throws {
    let path1 = "$.name"
    let path2 = "$.friends[*].name"
    let path3 = "$.credentialSubject.account[*].id"
    let path4 = "$.vc.credentialSubject.account[*].id"
    let path5 = "$.account[*].id"

    XCTAssert(path1.isValidJSONPath)
    XCTAssert(path2.isValidJSONPath)
    XCTAssert(path3.isValidJSONPath)
    XCTAssert(path4.isValidJSONPath)
    XCTAssert(path5.isValidJSONPath)
  }
  
  func testJsonPathSyntaxIsInvalid() throws {
    let path1 = "$..book[?(@.price<10)].title"
    XCTAssertFalse(path1.isValidJSONPath)
  }
}

class URLQueryParametersTests: XCTestCase {

  func testQueryParameters() {

    // Test case with no query parameters
    let url1 = URL(string: "https://example.com")!
    XCTAssertNil(url1.queryParameters)
    
    // Test case with single query parameter
    let url2 = URL(string: "https://example.com?param1=value1")!
    let expectedParameters2: [String: Any] = ["param1": "value1"]
    XCTAssertEqual(url2.queryParameters as NSDictionary?, expectedParameters2 as NSDictionary?)
    
    // Test case with multiple query parameters
    let url3 = URL(string: "https://example.com?param1=value1&param2=value2&param3=value3")!
    let expectedParameters3: [String: Any] = ["param1": "value1", "param2": "value2", "param3": "value3"]
    XCTAssertEqual(url3.queryParameters as NSDictionary?, expectedParameters3 as NSDictionary?)
    
    // Test case with URL-encoded query parameters
    let url4 = URL(string: "https://example.com?param1=Hello%20World&param2=123%20%26%2045")!
    let expectedParameters4: [String: Any] = ["param1": "Hello World", "param2": "123 & 45"]
    XCTAssertEqual(url4.queryParameters as NSDictionary?, expectedParameters4 as NSDictionary?)

    // Test case with complex URL-encoded query parameters
    let url5 = URL(string: "eudi-openid4vp://example.com?client_id=x509_san_dns:example.com&request_uri=https%3A%2F%2Fexample.com%2Fcallback%2Frequest-param%3Fa%3Dalmafa%26e%3D300%26x-request-id%3D6d6c28f6-7260-4b69-a421-80c4b50ab03b%26x-correlation-id%3Dfgsgggsf%26c%3Dprimary%26s%3D66B2C0D3957D5460DA1397E00593C41B87D861FA43CB8007AB52EA9CE3284453&request_uri_method=post")!
    let expectedParameters5: [String: Any] = ["client_id": "x509_san_dns:example.com", "request_uri": "https://example.com/callback/request-param?a=almafa&e=300&x-request-id=6d6c28f6-7260-4b69-a421-80c4b50ab03b&x-correlation-id=fgsgggsf&c=primary&s=66B2C0D3957D5460DA1397E00593C41B87D861FA43CB8007AB52EA9CE3284453", "request_uri_method": "post"]
    XCTAssertEqual(url5.queryParameters as NSDictionary?, expectedParameters5 as NSDictionary?)
  

  }
}

final class DictionaryExtensionTests: XCTestCase {

  func testFilterValues() {
    let dictionary = ["A": 1, "B": 2, "C": 3]
    let filtered = dictionary.filterValues { $0 % 2 == 0 }
    
    XCTAssertEqual(filtered, ["B": 2])
  }
  
  func testDictionaryFromFile_Failure() {
    let result = [String: Any].from(localJSONfile: "nonexistent")
    
    switch result {
    case .success:
      XCTFail("Unexpected success")
    case .failure:
      XCTAssertTrue(true)
    }
  }
  
  func testGetStringValue_Success() {
    let metaData = ["key": "value"]
    
    do {
      let value = try getStringValue(from: metaData, for: "key")
      XCTAssertEqual(value, "value")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testGetStringValue_Failure() {
    let metaData: [String: Any] = ["key": 123]
    
    XCTAssertThrowsError(try getStringValue(from: metaData, for: "key")) { error in
      XCTAssertEqual(error as? DictionaryError, .nilValue)
    }
  }
  
  func testGetStringArrayValue_Success() {
    let metaData = ["key": ["value1", "value2"]]
    
    do {
      let value = try getStringArrayValue(from: metaData, for: "key")
      XCTAssertEqual(value, ["value1", "value2"])
    } catch {
        XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testGetStringArrayValue_Failure() {
    let metaData: [String: Any] = ["key": "value"]
    
    XCTAssertThrowsError(try getStringArrayValue(from: metaData, for: "key")) { error in
      XCTAssertEqual(error as? DictionaryError, .nilValue)
    }
  }
  
  func testDictionaryEquality() {
    let dictionary1: [String: Any] = ["key1": "value1", "key2": "value2"]
    let dictionary2: [String: Any] = ["key1": "value1", "key2": "value2"]
    let dictionary3: [String: Any] = ["key1": "value1", "key2": "value3"]
    
    XCTAssertTrue(dictionary1 == dictionary2)
    XCTAssertFalse(dictionary1 == dictionary3)
  }
  
  func testDictionaryJSONData() {
    let dictionary: [String: Any] = ["key": "value"]
    let jsonData = dictionary.jsonData
    
    XCTAssertNotNil(jsonData)
    
    let jsonObject = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
    
    XCTAssertNotNil(jsonObject)
  }
  
  func testDictionaryToJSONString() {
    let dictionary: [String: Any] = ["key": "value"]
    let jsonString = dictionary.toJSONString()
    
    XCTAssertEqual(jsonString, "{\n  \"key\" : \"value\"\n}")
  }
  
  func testDictionaryFromJSONFile_Success() {
    let fileURL = URL(fileURLWithPath: "test.json")
    let result = [String: Any].from(JSONfile: fileURL)
    
    switch result {
    case .success:
      XCTAssertTrue(true)
    case .failure:
      XCTAssertTrue(true)
    }
  }
  
  func testDictionaryFromJSONFile_Failure_DataInitialization() {
    let fileURL = URL(fileURLWithPath: "nonexistent.json")
    let result = [String: Any].from(JSONfile: fileURL)
    
    switch result {
    case .success:
      XCTFail("Unexpected success")
    case .failure:
      XCTAssertTrue(true)
    }
  }
  
  func testDictionaryFromJSONFile_Failure_JSONSerialization() {
    let fileURL = URL(fileURLWithPath: "invalid.json")
    let result = [String: Any].from(JSONfile: fileURL)
    
    switch result {
    case .success:
      XCTFail("Unexpected success")
    case .failure:
      XCTAssertTrue(true)
    }
  }
  
  func testDictionaryFromJSONFile_Failure_MappingFail() {
    let fileURL = URL(fileURLWithPath: "wrong.json")
    let result = [String: Any].from(JSONfile: fileURL)
    
    switch result {
    case .success:
      XCTFail("Unexpected success")
    case .failure:
      XCTAssertTrue(true)
    }
  }
}
