import Foundation

public enum PresentationError: LocalizedError {
  case invalidFormat
  case invalidPresentationDefinition
  case conflictingData

  public var errorDescription: String? {
    switch self {
    case .invalidFormat:
      return ".invalidFormat"
    case .invalidPresentationDefinition:
      return ".invalidPresentationDefinition"
    case .conflictingData:
      return ".conflictingData"
    }
  }
}
