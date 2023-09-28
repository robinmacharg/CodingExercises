//
//  AppNetworkable.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 15.01.2022.
//

import Foundation

public protocol AppNetworkable {
    /// `URLRequest` of the request.
    var request: URLRequest { get }
}

public extension AppNetworkable {
    func getRequest<T: Encodable>(with path: String, encodable data: T, httpMethod: RequestType) -> URLRequest {
        var request = getRequest(with: path, httpMethod: httpMethod)
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            print("JSON Encode Error")
        }
        return request
    }
    
    func getRequest(with path: String, httpMethod: RequestType) -> URLRequest {
        var request = URLRequest(url: API.getURL(with: path))
        request.httpMethod = httpMethod.rawValue
        API.getHeaders().forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }
    
    func fetchResponse<V: Decodable>(completion: @escaping ((Result<V, Error>) -> Void)) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(NSError.error(with: "Data error")))
                    return
                }
                
                print("The response is : ",String(data: data, encoding: .utf8)!)
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let httpStatus = response as? HTTPURLResponse {
                        switch httpStatus.statusCode {
                        case 200: // Success
                            do {
                                let result = try JSONDecoder().decode(V.self, from: data)
                                completion(.success(result))
                                
                            } catch let error as NSError {
                                print("JSON Decode Error")
                                completion(.failure(error))
                            }
                        default:
                            do {
                                let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let message = result.validationErrors?.first?.message ?? result.message ?? ""
                                completion(.failure(NSError.error(with: message)))
                                
                            } catch {
                                completion(.failure(NSError.error(with: "Https error code: \(httpStatus.statusCode)")))
                            }
                        }
                    } else {
                        completion(.failure(NSError.error(with: "Https error")))
                    }
                }
            }
        }
        task.resume()
    }
}

public extension NSError {
    static func error(with localizedDescription: String) -> NSError {
        NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

public enum RequestType : String {
    /// HTTP GET request
    case GET
    /// HTTP POST request
    case POST
}
