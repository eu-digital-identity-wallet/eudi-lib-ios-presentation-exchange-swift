import Foundation

/*
 *
 * https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-authorization-request
 */
public struct AuthorizationRequestUnprocessedData: Codable {
  public let responseType: String?
  public let responseUri: String?
  public let redirectUri: String?
  public let presentationDefinition: String?
  public let presentationDefinitionUri: String?
  public let request: String?
  public let requestUri: String?
  public let clientMetaData: String?
  public let clientId: String?
  public let clientMetadataUri: String?
  public let clientIdScheme: String?
  public let nonce: String?
  public let scope: String?
  public let responseMode: String?
  public let state: String? // OpenId4VP specific, not utilized from ISO-23330-4
  public let idTokenType: String?

  enum CodingKeys: String, CodingKey {
    case responseType = "response_type"
    case responseUri = "response_uri"
    case redirectUri = "redirect_uri"
    case presentationDefinition = "presentation_definition"
    case presentationDefinitionUri = "presentation_definition_uri"
    case clientId = "client_id"
    case clientMetaData = "client_meta_data"
    case clientMetadataUri = "client_metadata_uri"
    case clientIdScheme = "client_id_scheme"
    case nonce
    case scope
    case responseMode = "response_mode"
    case state = "state"
    case idTokenType = "id_token_type"
    case request
    case requestUri = "request_uri"
  }

  public init(
    responseType: String? = nil,
    responseUri: String? = nil,
    redirectUri: String? = nil,
    presentationDefinition: String? = nil,
    presentationDefinitionUri: String? = nil,
    request: String? = nil,
    requestUri: String? = nil,
    clientMetaData: String? = nil,
    clientId: String? = nil,
    clientMetadataUri: String? = nil,
    clientIdScheme: String? = nil,
    nonce: String? = nil,
    scope: String? = nil,
    responseMode: String? = nil,
    state: String? = nil,
    idTokenType: String? = nil) {
      self.responseType = responseType
      self.responseUri = responseUri
      self.redirectUri = redirectUri
      self.presentationDefinition = presentationDefinition
      self.presentationDefinitionUri = presentationDefinitionUri
      self.request = request
      self.requestUri = requestUri
      self.clientMetaData = clientMetaData
      self.clientId = clientId
      self.clientMetadataUri = clientMetadataUri
      self.clientIdScheme = clientIdScheme
      self.nonce = nonce
      self.scope = scope
      self.responseMode = responseMode
      self.state = state
      self.idTokenType = idTokenType
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    responseType = try? container.decode(String.self, forKey: .responseType)
    responseUri = try? container.decode(String.self, forKey: .responseUri)
    redirectUri = try? container.decode(String.self, forKey: .redirectUri)

    presentationDefinition = try? container.decode(String.self, forKey: .presentationDefinition)
    presentationDefinitionUri = try? container.decode(String.self, forKey: .presentationDefinitionUri)

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
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try? container.encode(responseType, forKey: .responseType)
    try? container.encode(responseUri, forKey: .responseUri)
    try? container.encode(redirectUri, forKey: .redirectUri)

    try? container.encode(presentationDefinition, forKey: .presentationDefinition)
    try? container.encode(presentationDefinitionUri, forKey: .presentationDefinitionUri)

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
  }
}

public extension AuthorizationRequestUnprocessedData {
  init?(from url: URL) {
    let parameters = url.queryParameters

    responseType = parameters?[CodingKeys.responseType.rawValue] as? String
    responseUri = parameters?[CodingKeys.responseUri.rawValue] as? String
    redirectUri = parameters?[CodingKeys.redirectUri.rawValue] as? String

    presentationDefinition = parameters?[CodingKeys.presentationDefinition.rawValue] as? String
    presentationDefinitionUri = parameters?[CodingKeys.presentationDefinitionUri.rawValue] as? String

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
  }
}

public extension AuthorizationRequestUnprocessedData {
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
