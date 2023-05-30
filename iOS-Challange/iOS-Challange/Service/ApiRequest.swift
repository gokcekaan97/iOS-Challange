//
//  ApiRequest.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation

final class ApiRequest {
  private struct Constants {
     static let baseUrl = "https://api.rawg.io/api"
  }
  private let endpoint: ApiEndpoint
  private let apiKey = "?key=3be8af6ebf124ffe81d90f514e59856c"
  static let gamesApiRequest = ApiRequest(endpoint: .games)
  private let queryParameters: [URLQueryItem]
  private var urlString: String{
    var string = Constants.baseUrl
    string += endpoint.rawValue
    string += apiKey
    if !queryParameters.isEmpty{
      let parameters = queryParameters.compactMap({
        guard let value = $0.value else { return nil }
        return "\($0.name)=\(value)"
      }).joined(separator: "&")
    string += parameters
    }
    return string
  }
  public var url: URL?{
    return URL(string: urlString)
  }
  public init(endpoint: ApiEndpoint, queryParameters: [URLQueryItem] = []) {
    self.endpoint = endpoint
    self.queryParameters = queryParameters
  }
}
