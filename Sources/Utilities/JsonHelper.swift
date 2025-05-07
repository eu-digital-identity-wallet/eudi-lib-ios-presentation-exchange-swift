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

/// A utility to help with JSON parsing from query parameters.
internal struct JsonHelper {
  /// Parses a JSON array from the query parameter in the provided URL.
  /// - Parameters:
  ///   - parameter: The query parameter key.
  ///   - url: The URL containing the query parameter.
  /// - Returns: An optional array of JSON elements, or `nil` if parsing fails.
  static func jsonArray(for parameter: String, from url: URL) -> [JSON]? {
    guard
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
      let paramValue = queryItems.first(where: { $0.name == parameter })?.value,
      let data = paramValue.data(using: .utf8)
    else {
      return nil
    }
    
    let json = try? JSON(data: data)
    return json?.array
  }
}
