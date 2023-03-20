//
//  APIService.swift
//  Marketplace
//
//  Created by Robin Macharg on 20/03/2023.
//

import Foundation

struct Empty: Encodable {}

final class APIService {
    static let shared: APIService = APIService()
    private init() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = 2.0
        urlSessionConfiguration.timeoutIntervalForResource = 2.0
        urlSessionConfiguration.httpAdditionalHeaders = [:]

        urlSession = URLSession(configuration: urlSessionConfiguration)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    /// A custom configurable URLSession
    private var urlSession: URLSession

    private let decoder = JSONDecoder()

    /// Network requests happen on a background thead
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
}

extension APIService {
    enum HTTPMethod: String, RawRepresentable {
        case GET
        case POST
    }

    /**
     * Creates a URLRequest from URL, method and (optionally) a JSON-Encodable object
     */
    func makeURLRequest<T: Encodable>(_ url: String, method: HTTPMethod = .GET, body: T? = nil) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

//        if let bodyObject = body, let requestBody = try? JSONEncoder().encode(bodyObject) {
//            request.httpBody = requestBody
//        }

//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    @discardableResult
    func makeAsyncRequest<InputType: Encodable, OutputType: Decodable>(
        _ url: String,
        method: HTTPMethod = .POST,
        body: InputType? = nil,
        returnType: OutputType.Type,
        debug: Bool = false) async throws -> OutputType {
        guard let request = makeURLRequest(url, method: method, body: body) else {
            let message = "Unable to create a \(method) request with a \(InputType.self) body " +
                "(\(String(describing: body)), returning \(returnType)"
            Log.error(message)

            throw APIServiceError.unhandledError
        }

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIServiceError.nonHTTPURLResponse
        }

        switch httpResponse.statusCode {

        case 200:
            // A normal request - parse the response type

            if debug {
                Log.debug("Response for \(url): " +
                          "(request body: \n\(request.httpBody?.toJSON(pretty: true) ?? "Unhandled body")\nis:\n" +
                          (data.toJSON() ?? "JSON data malformed"))
            }

            // Translate "null" response to valid (empty, and from our point of view) JSON
            // Top level JSON fragments is a gray area w.r.t. Codables.
            if String(data: data, encoding: .utf8) == "null",
                let data = "{}".data(using: .utf8) {
                let response = try decoder.decode(OutputType.self, from: data)
                return response
            } else {
                do {
                    let response: OutputType = try decoder.decode(OutputType.self, from: data)
                    return response
                } catch let error {
                    Log.error("JSON Parsing error: \(error)")
                    throw APIServiceError.jsonDecodingError(
                        structName: "\(OutputType.self)",
                        details: "Failed to parse response: \(error)")
                }
            }

        default:
            // Let the caller handle the response
            throw APIServiceError.non200Response(request: request, response: httpResponse)
        }
    }
}
