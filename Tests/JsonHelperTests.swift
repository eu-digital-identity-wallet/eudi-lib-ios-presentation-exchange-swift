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
import SwiftyJSON

@testable import PresentationExchange


final class JsonHelperTests: XCTestCase {
  
  func testJsonArrayParsingSuccess() {
    // Prepare a URL with a transaction_data query parameter.
    // The query parameter is a JSON array encoded as a string.
    let jsonString = "[\"data1\",\"data2\"]"
    guard let encodedQuery = jsonString.addingPercentEncoding(
      withAllowedCharacters: .urlQueryAllowed
    ) else {
      XCTFail("Failed to encode query string")
      return
    }
    let urlString = "https://example.com?\("transaction_data")=\(encodedQuery)"
    
    guard let url = URL(string: urlString) else {
      XCTFail("Failed to create URL from string")
      return
    }
    
    // Call the static function.
    guard let jsonArr = JsonHelper.jsonArray(for: "transaction_data", from: url) else {
      XCTFail("jsonArray(for:from:) returned nil")
      return
    }
    
    // Map JSON elements to strings.
    let values = jsonArr.compactMap { $0.string }
    XCTAssertEqual(values, ["data1", "data2"], "Parsed array does not match expected values")
  }
  
  func testJsonArrayParsingInvalidURL() {
    // Create a URL with no valid query parameter.
    guard let url = URL(string: "https://example.com") else {
      XCTFail("Failed to create URL")
      return
    }
    
    let jsonArr = JsonHelper.jsonArray(for: "transaction_data", from: url)
    XCTAssertNil(jsonArr, "Expected nil when query parameter is missing")
  }
  
  func testJsonArrayParsingInvalidJSON() {
    // Create a URL with an invalid JSON value for the parameter.
    let invalidJSONString = "not a json array"
    guard let encodedQuery = invalidJSONString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      XCTFail("Failed to encode query string")
      return
    }
    let urlString = "https://example.com?\("transaction_data")=\(encodedQuery)"
    
    guard let url = URL(string: urlString) else {
      XCTFail("Failed to create URL from string")
      return
    }
    
    let jsonArr = JsonHelper.jsonArray(for: "transaction_data", from: url)
    XCTAssertNil(jsonArr, "Expected nil when JSON parsing fails")
  }
}

