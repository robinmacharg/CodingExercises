//
//  API.swift
//  Superheroes
//
//  Created by Robin Macharg2 on 02/08/2021.
//
// Handles network communication with the backend.  A Singleton.

import Foundation

public final class API {

    // Singleton
    public static let shared = API()

    struct constants {
        static let endPoint = "https://httpbin.org/anything"
    }

    // Private to support the singleton pattern
    private init() {}

    /**
     * Construct a URLRequest object
     */
    static func makeURLRequest(squads: [SuperheroSquad]) -> Result<URLRequest, SuperHeroError> {
        let json = Data.squadsAsJSON(squads: squads)
        switch json {
        case .success(let jsonString):
            guard let url = URL(string: API.constants.endPoint) else {
                return .failure(.generalError(SuperHeroError.errorTexts.urlError))
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonString.data(using: .utf8)
            urlRequest.setValue("\(String(describing: jsonString.data(using: .utf8)?.count))", forHTTPHeaderField: "Content-Length")
            
            return .success(urlRequest)
        
        case .failure(let error):
            switch error {
            case .failedToEncode:
                return .failure(error)
            default:
                return .failure(SuperHeroError.generalError(SuperHeroError.errorTexts.generalError))
            }
        }
    }
    
    /**
     * Send the request.  Uses a URLSession dataTask to ensure a background thread.
     */
    static func sendRequest(_ request: Request, callback: ((Any) -> ())?) {
        let urlRequest = request.request
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            // NOTE: artifical delay to help show async update of table
            sleep(UInt32.random(in: 0...2))

            // The next two guards are copy/paste boilerplate

            // Check for fundamental networking error
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Unknown error")
                return
            }

            // Check for HTTP errors
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            // Parse out data field
            if let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let json = response["data"] as? String,
               let data = json.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                let superheroSquads = try? decoder.decode([SuperheroSquad].self, from: data)
                request.returnedData = superheroSquads

                callback?(request)
            }

            // Error
            else {
                fatalError("unhandled")
            }
        }

        task.resume()
    }
}
