//
//  APIService.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import Foundation

/// An artificial delay on network requests to show off UI state changes.
private let delaySeconds: Double = 1

/**
 * A singleton API service that uses async to request data from the backend
 */
final class APIService {
    static let shared: APIService = .init()
    private init() {

        decoder = JSONDecoder()

        // Handle dates of the form "yyyy-MM-dd'T'HH:mm:ss.SSSZ" e.g. 2021-11-10T14:24:19.604Z
        decoder.dateDecodingStrategy = .formatted(DateFormatter.coinGeckoFormat)

        // Custom configuration to reduce potential timeouts for debugging/task evaluation
        let urlSessionConfiguration = URLSessionConfiguration.default
//        urlSessionConfiguration.timeoutIntervalForRequest = 2.0
//        urlSessionConfiguration.timeoutIntervalForResource = 2.0
        urlSessionConfiguration.httpAdditionalHeaders = [:]

        urlSession = URLSession(configuration: urlSessionConfiguration)
    }

    /// A custom configurable URLSession
    private var urlSession: URLSession

    /// We only need a single JSON decoder
    private let decoder: JSONDecoder

    /// Network requests happen on a background thead
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
}

extension APIService {
    enum HTTPMethod: String, RawRepresentable {
        case GET
        case POST // Unused in this case; left for illustration
    }

    /**
     * Creates a URLRequest from URL, and method
     */
    func makeURLRequest(_ url: String, method: HTTPMethod = .GET) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return request
    }

    /**
     * Performs an asynchronous request for JSON data.
     * The return type is used to automate decoding.  No body data is required for this example but could also be
     * provided in a generic form.
     */
    @discardableResult
    func makeAsyncRequest<OutputType: Decodable>(
        _ url: String,
        method: HTTPMethod = .GET,
        returnType: OutputType.Type,
        debug: Bool = false) async throws -> OutputType
    {
        guard let request = makeURLRequest(url, method: method) else {
            let message = "Unable to create a \(method) request, returning \(returnType)"
            Log.error(message)

            throw APIServiceError.unhandledError
        }

        //
        // NOTE: Artificial delay to demonstrate UI state changes:
        //

        try await Task.sleep(nanoseconds: UInt64(delaySeconds * Double(NSEC_PER_SEC)))

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIServiceError.nonHTTPURLResponse
        }

        switch httpResponse.statusCode {

        case 200:
            // A normal request - parse the response type

            if (debug && DebugRequests.cURL) || DebugRequests.all {
                Log.debug("Response for \(url): is:\n" + (data.toJSON() ?? "JSON data malformed"))
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

            // Room here for handling other specific response codes at the API level (e.g. mandatory app upgrades,
            // authentication failure etc)

        default:
            // Let the caller handle the response; we could also catch this and return a Result type.
            throw APIServiceError.non200Response(request: request, response: httpResponse)
        }
    }
}
