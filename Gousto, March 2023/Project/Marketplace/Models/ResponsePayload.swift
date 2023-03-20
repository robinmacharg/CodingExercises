// MARK: - ResponsePayload

/// The ``ResponsePayload`` is a generic type which represents a payload received from an API request.
struct ResponsePayload<T: Decodable>: Decodable {

    /// The status indicating whether the API request was successful or not.
    let status: String

    /// The payload's primary data.
    let data: T
}
