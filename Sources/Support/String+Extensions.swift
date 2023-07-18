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

public extension String {

  func isValidDate(dateFormat: String = "yyyy-MM-dd") -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat

    return dateFormatter.date(from: self) != nil
  }

  func isValidJWT() -> Bool {
      let jwtPattern = "^([A-Za-z0-9-_=]+)\\.([A-Za-z0-9-_=]+)\\.([A-Za-z0-9-_.+/=]*)$"
    guard let jwtRegex = try? NSRegularExpression(pattern: jwtPattern, options: []) else { return false }

      let matches = jwtRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf8.count))

      return matches.count == 1
  }

  func convertToDictionary() throws -> [String: Any]? {
    if let jsonData = self.data(using: .utf8) {
      let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
      return dictionary
    }
    return nil
  }

  // swiftlint:disable line_length
  var isValidJSONPath: Bool {
    guard
      let regex = try? NSRegularExpression(
        pattern: #"^\$((\.[\w-]+)|(\[[0-9]+\])|(\[\*\])|(\[\?\(@[\w-]+\s?(==|!=|<|<=|>|>=)\s?(['"])?[\w-]+(['"])?\)]))+$"#
      ) else {
      return false
    }
    let range = NSRange(location: 0, length: self.utf16.count)
    return regex.firstMatch(in: self, options: [], range: range) != nil
  }
  // swiftlint:enable line_length

  var isValidJSONString: Bool {
    guard let data = self.data(using: .utf8) else {
      return false
    }

    do {
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      return json is [String: Any] || json is [Any]
    } catch {
      return false
    }
  }
}
