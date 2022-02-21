//
//  API.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import UIKit

/**
 * A singleton to handle all API requests.
 * Can be configured with a custom URLSession to support testing
 */
public final class API {

    // Singleton
    public static let shared = API()
    
    // The URLSession to use for requests.  Injectable.
    var defaultSession: URLSession
    
    // Fixed API endpoints
    struct endpoints {
        static let markets = "https://content.dailyfx.com/api/v1/markets"
        static let articles = "https://content.dailyfx.com/api/v1/dashboard"
    }

    /**
     * Initialise the API.  Accepts an optional URLSession to be injected allow for unit testing.
     */
    static func initialise(session: URLSession = URLSession(configuration: .default)) {
        API.shared.defaultSession = session
    }
    
    // Private to support the singleton pattern
    private init() {
        defaultSession = URLSession(configuration: .default)
    }

    // MARK: - Markets API
    
    // TODO: There's obvious redundancy in the next two methods.  These should be parameterised and/or genericised.
    // The Markets & Articles types can provide their own endpoints.  We just need to pass their type.
    func getMarkets(_ callback: ((Result<Markets, IGFxError>) -> Void)?) {
        if let url = URL(string: API.endpoints.markets) {
            let task = defaultSession.marketsTask(with: url) { markets, response, error in
                if error != nil {
                    callback?(.failure(IGFxError.networkError("\(error?.localizedDescription ?? "No description provided")")))
                }
                else {
                    if let markets = markets {
                        callback?(.success(markets))
                    }
                    else {
                        callback?(.failure(IGFxError.networkError(nil)))
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Articles API
    
    func getArticles(_ callback: ((Result<Articles, IGFxError>) -> Void)?) {
        if let url = URL(string: API.endpoints.articles) {
            let task = defaultSession.articlesTask(with: url) { articles, response, error in
                if error != nil {
                    callback?(.failure(IGFxError.networkError("\(error?.localizedDescription ?? "No description provided")")))
                }
                else {
                    if let articles = articles {
                        callback?(.success(articles))
                    }
                    else {
                        callback?(.failure(IGFxError.dataError()))
                    }
                }
            }
            task.resume()
        }
    }
    
    /**
     * Retrieve arbitrary data from a URL.  Used to e.g. get article detail images.
     */
    func getData(url urlString: String, _ callback: ((Result<Data, IGFxError>) -> Void)?) {
        
        if let url = URL(string: urlString) {
            let task = self.defaultSession.dataTask(with: url, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    callback?(.failure(IGFxError.networkError("Failed to load data: \(urlString)")))
                    return
                }
                
                callback?(.success(data))
            })
            task.resume()
        }
    }
}
