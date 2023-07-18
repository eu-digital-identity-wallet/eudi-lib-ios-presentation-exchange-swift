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

public enum ParserError: LocalizedError, Equatable {
  case notFound
  case invalidData
  case decodingFailure(String)

  public var errorDescription: String? {
    switch self {
    case .notFound:
      return ".notFound"
    case .invalidData:
      return ".invalidData"
    case .decodingFailure(let failure):
      return ".decodingFailure \(failure)"
    }
  }
}

public protocol ParserType {
  func decode<T: Codable>(path: String, type: String) -> Result<T, ParserError>
  func decode<T: Codable>(json: String) -> Result<T, ParserError>
}

public class Parser: ParserType {
  public init() { }
  public func decode<T: Codable>(json: String) -> Result<T, ParserError> {
    guard
      let data = json.data(using: .utf8)
    else {
      return .failure(.invalidData)
    }

    let decoder = JSONDecoder()

    do {
       let presentationDefinition = try decoder.decode(T.self, from: data)
      return .success(presentationDefinition)

    } catch {
      return .failure(.decodingFailure(error.localizedDescription))
    }
  }

  public func decode<T: Codable>(path: String, type: String) -> Result<T, ParserError> {

    guard
      let path = Bundle.module.path(forResource: path, ofType: type)
    else {
      return .failure(.notFound)
    }

    let url = URL(fileURLWithPath: path)

    guard
      let data = try? Data(contentsOf: url)
    else {
      return .failure(.invalidData)
    }

    let decoder = JSONDecoder()

    do {
      let object = try decoder.decode(T.self, from: data)
      return .success(object)

    } catch {
      return .failure(.decodingFailure(error.localizedDescription))
    }
  }
}
