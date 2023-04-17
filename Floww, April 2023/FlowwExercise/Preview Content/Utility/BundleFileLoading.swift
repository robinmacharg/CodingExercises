//
//  BundleFileLoading.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 13/04/2023.
//

import Foundation

#if DEBUG
extension Bundle {

    /**
     * Convenience method to load file contents from the bundle
     */
    func getFileContents(_ filename: String) -> String? {

        let pathExtension = NSString(string: filename).pathExtension
        let pathPrefix = NSString(string: filename).deletingPathExtension

        if let filepath = self.path(forResource: pathPrefix, ofType: pathExtension) {
            return try? String(contentsOfFile: filepath)
        }

        return nil
    }
}

/**
 * Provides a convenience function to load and decode a JSON file from the bundle
 */
protocol BundleFileLoading {
    static func getBundleFile<T: Decodable>(_ filename: String, as returnType: T.Type) -> T
}

extension BundleFileLoading {
    static func getBundleFile<T: Decodable>(_ filename: String, as returnType: T.Type) -> T {
        guard let bundle = Bundle(identifier: "org.macharg.FlowwExercise"),
              let json = bundle.getFileContents(filename) else
        {
            fatalError("Failed to get file from test bundle: \(filename)")
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.coinGeckoFormat)
            let data = try decoder.decode(T.self, from: Data(json.utf8))
            return data
        }
        catch let error {
            fatalError("Failed to decode file (\(filename)): \(error.localizedDescription)")
        }
    }
}
#endif
