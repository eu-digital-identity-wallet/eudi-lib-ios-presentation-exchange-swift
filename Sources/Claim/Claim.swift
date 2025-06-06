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
@preconcurrency import SwiftyJSON

public struct Claim: Sendable {
  public let id: ClaimId
  public let format: String
  public let jsonObject: JSON

  public init(
    id: ClaimId,
    format: String,
    jsonObject: JSON
  ) {
    self.id = id
    self.format = format
    self.jsonObject = jsonObject
  }
}
