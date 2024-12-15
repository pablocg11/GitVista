import Foundation

protocol HTTPClientProtocol {
    func makeRequest(_ request: HTTPRequest) async -> Result<Data, HTTPClientError>
}

final class HTTPClient: HTTPClientProtocol {
    let session: URLSession
    let errorsResolver: HTTPErrorsResolver
    let requestBuilder: HTTPRequestBuilder
    
    init(session: URLSession = .shared,
         errorsResolver: HTTPErrorsResolver,
         requestBuilder: HTTPRequestBuilder) {
        self.session = session
        self.errorsResolver = errorsResolver
        self.requestBuilder = requestBuilder
    }
    
    func makeRequest(_ request: HTTPRequest) async -> Result<Data, HTTPClientError> {
        guard let url = requestBuilder.url(request: request) else {
            return .failure(.badURL)
        }
        
        do {
            let result = try await session.data(from: url)
            
            guard let response = result.1 as? HTTPURLResponse else {
                return .failure(.responseError)
            }
            
            guard response.statusCode == 200 else {
                return .failure(errorsResolver.resolve(errorCode: response.statusCode))
            }
            
            return .success(result.0)
        } catch {
            return .failure(errorsResolver.resolve(error: error))
        }
        
    }
}
