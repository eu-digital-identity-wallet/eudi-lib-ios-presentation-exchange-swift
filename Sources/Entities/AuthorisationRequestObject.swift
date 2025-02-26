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

/*
 *
 * https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-authorization-request
 */
public struct AuthorisationRequestObject: Codable {
  public let responseType: String?
  public let responseUri: String?
  public let redirectUri: String?
  public let presentationDefinition: String?
  public let presentationDefinitionUri: String?
  public let dcqlQuery: JSON?
  public let request: String?
  public let requestUri: String?
  public let requestUriMethod: String?
  public let clientMetaData: String?
  public let clientId: String?
  public let clientMetadataUri: String?
  public let clientIdScheme: String?
  public let nonce: String?
  public let scope: String?
  public let responseMode: String?
  public let state: String? // OpenId4VP specific, not utilized from ISO-23330-4
  public let idTokenType: String?
  public let supportedAlgorithm: String?
  public let transactionData: [String]?
  
  enum CodingKeys: String, CodingKey {
    case responseType = "response_type"
    case responseUri = "response_uri"
    case redirectUri = "redirect_uri"
    case presentationDefinition = "presentation_definition"
    case presentationDefinitionUri = "presentation_definition_uri"
    case dcqlQuery = "dcql_query"
    case clientId = "client_id"
    case clientMetaData = "client_metadata"
    case clientMetadataUri = "client_metadata_uri"
    case clientIdScheme = "client_id_scheme"
    case nonce
    case scope
    case responseMode = "response_mode"
    case state = "state"
    case idTokenType = "id_token_type"
    case request
    case requestUri = "request_uri"
    case requestUriMethod = "request_uri_method"
    case supportedAlgorithm = "supported_algorithm"
    case transactionData = "transaction_data"
  }
  
  public init(
    responseType: String? = nil,
    responseUri: String? = nil,
    redirectUri: String? = nil,
    presentationDefinition: String? = nil,
    presentationDefinitionUri: String? = nil,
    dcqlQuery: JSON? = nil,
    request: String? = nil,
    requestUri: String? = nil,
    requestUriMethod: String? = nil,
    clientMetaData: String? = nil,
    clientId: String? = nil,
    clientMetadataUri: String? = nil,
    clientIdScheme: String? = nil,
    nonce: String? = nil,
    scope: String? = nil,
    responseMode: String? = nil,
    state: String? = nil,
    idTokenType: String? = nil,
    supportedAlgorithm: String? = nil,
    transactionData: [String]? = nil
  ) {
    self.responseType = responseType
    self.responseUri = responseUri
    self.redirectUri = redirectUri
    self.presentationDefinition = presentationDefinition
    self.presentationDefinitionUri = presentationDefinitionUri
    self.dcqlQuery = dcqlQuery
    self.request = request
    self.requestUri = requestUri
    self.requestUriMethod = requestUriMethod
    self.clientMetaData = clientMetaData
    self.clientId = clientId
    self.clientMetadataUri = clientMetadataUri
    self.clientIdScheme = clientIdScheme
    self.nonce = nonce
    self.scope = scope
    self.responseMode = responseMode
    self.state = state
    self.idTokenType = idTokenType
    self.supportedAlgorithm = supportedAlgorithm
    self.transactionData = transactionData
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    responseType = try? container.decode(String.self, forKey: .responseType)
    responseUri = try? container.decode(String.self, forKey: .responseUri)
    redirectUri = try? container.decode(String.self, forKey: .redirectUri)
    
    presentationDefinition = try? container.decode(String.self, forKey: .presentationDefinition)
    presentationDefinitionUri = try? container.decode(String.self, forKey: .presentationDefinitionUri)
    dcqlQuery = try? container.decode(JSON.self, forKey: .dcqlQuery)
    
    clientId = try? container.decode(String.self, forKey: .clientId)
    clientMetaData = try? container.decode(String.self, forKey: .clientMetaData)
    clientMetadataUri = try? container.decode(String.self, forKey: .clientMetadataUri)
    
    clientIdScheme = try? container.decode(String.self, forKey: .clientIdScheme)
    nonce = try? container.decode(String.self, forKey: .nonce)
    scope = try? container.decode(String.self, forKey: .scope)
    responseMode = try? container.decode(String.self, forKey: .responseMode)
    state = try? container.decode(String.self, forKey: .state)
    
    idTokenType = try? container.decode(String.self, forKey: .idTokenType)
    
    request = try? container.decode(String.self, forKey: .request)
    requestUri = try? container.decode(String.self, forKey: .requestUri)
    requestUriMethod = try? container.decode(String.self, forKey: .requestUriMethod)
    
    supportedAlgorithm = try? container.decode(String.self, forKey: .supportedAlgorithm)
    
    transactionData = try? container.decode([String].self, forKey: .transactionData)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try? container.encode(responseType, forKey: .responseType)
    try? container.encode(responseUri, forKey: .responseUri)
    try? container.encode(redirectUri, forKey: .redirectUri)
    
    try? container.encode(presentationDefinition, forKey: .presentationDefinition)
    try? container.encode(presentationDefinitionUri, forKey: .presentationDefinitionUri)
    try? container.encode(dcqlQuery, forKey: .dcqlQuery)
    
    try? container.encode(clientId, forKey: .clientId)
    try? container.encode(clientMetaData, forKey: .clientMetaData)
    try? container.encode(clientMetadataUri, forKey: .clientMetadataUri)
    try? container.encode(clientIdScheme, forKey: .clientIdScheme)
    
    try? container.encode(nonce, forKey: .nonce)
    try? container.encode(scope, forKey: .scope)
    try? container.encode(responseMode, forKey: .responseMode)
    try? container.encode(state, forKey: .state)
    
    try? container.encode(idTokenType, forKey: .idTokenType)
    
    try? container.encode(request, forKey: .request)
    try? container.encode(requestUri, forKey: .requestUri)
    try? container.encode(requestUriMethod, forKey: .requestUriMethod)
    
    try? container.encode(supportedAlgorithm, forKey: .supportedAlgorithm)
    try? container.encode(transactionData, forKey: .transactionData)
  }
}

public extension AuthorisationRequestObject {
  init?(from url: URL) {
    let parameters = url.queryParameters
    
    responseType = parameters?[CodingKeys.responseType.rawValue] as? String
    responseUri = parameters?[CodingKeys.responseUri.rawValue] as? String
    redirectUri = parameters?[CodingKeys.redirectUri.rawValue] as? String
    
    presentationDefinition = parameters?[CodingKeys.presentationDefinition.rawValue] as? String
    presentationDefinitionUri = parameters?[CodingKeys.presentationDefinitionUri.rawValue] as? String
    
    if let dcqlString = parameters?[CodingKeys.dcqlQuery.rawValue] as? String,
       let jsonData = dcqlString.data(using: .utf8) {
      dcqlQuery = try? JSON(data: jsonData)
    } else {
      dcqlQuery = nil
    }
    
    clientId = parameters?[CodingKeys.clientId.rawValue] as? String
    clientMetaData = parameters?[CodingKeys.clientMetaData.rawValue] as? String
    clientMetadataUri = parameters?[CodingKeys.clientMetadataUri.rawValue] as? String
    
    clientIdScheme = parameters?[CodingKeys.clientIdScheme.rawValue] as? String
    nonce = parameters?[CodingKeys.nonce.rawValue] as? String
    scope = parameters?[CodingKeys.scope.rawValue] as? String
    responseMode = parameters?[CodingKeys.responseMode.rawValue] as? String
    state = parameters?[CodingKeys.state.rawValue] as? String
    
    idTokenType = parameters?[CodingKeys.idTokenType.rawValue] as? String
    
    request = parameters?[CodingKeys.request.rawValue] as? String
    requestUri = parameters?[CodingKeys.requestUri.rawValue] as? String
    requestUriMethod = parameters?[CodingKeys.requestUriMethod.rawValue] as? String
    
    supportedAlgorithm = parameters?[CodingKeys.supportedAlgorithm.rawValue] as? String
    transactionData = JsonHelper.jsonArray(
      for: "transaction_data",
      from: url
    )?.compactMap { $0.string }
  }
}

public extension AuthorisationRequestObject {
  var hasClientMetaData: Bool {
    return clientMetaData != nil || clientMetadataUri != nil
  }
  
  var hasPresentationDefinitions: Bool {
    return presentationDefinition != nil || presentationDefinitionUri != nil
  }
  
  var hasRequests: Bool {
    return request != nil || requestUri != nil
  }
  
  var hasConflicts: Bool {
    return (hasClientMetaData || hasPresentationDefinitions) && hasRequests
  }
}

/// A utility to help with JSON parsing from query parameters.
struct JsonHelper {
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
