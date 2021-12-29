import Foundation

enum ApiError: Error{
    case unknown
    case invalidURL(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}
