//
//  NetworkRequestManager.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core

typealias JSON = [String: Any]

/// Class for making network requests
final class NetworkRequestManager: NetworkRequestManagerProtocol {
    
    // MARK: - Properties
    
    private let urlSession: URLSession
    private static let errorDomain =
        "com.appgate.Appgate.Repository.NetworkError"
    
    // MARK: - Initializers
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Internal Functions
    
    func makeRequest<T: Model>(
        url: URL,
        httpMethod: HTTPMethod,
        parameters: JSON?,
        modelType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
        makeRequest(url: url,
                    httpMethod: httpMethod,
                    parameters: parameters) { result in
            func callCompletion(result: Result<T, Error>) {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                do {
                    let model = try decoder.decode(modelType, from: data)
                    callCompletion(result: .success(model))
                } catch let error {
                    callCompletion(result: .failure(error))
                }
            case .failure(let error):
                callCompletion(result: .failure(error))
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func makeRequest(url: URL,
                             httpMethod: HTTPMethod,
                             parameters: JSON?,
                             completion: @escaping (Result<Data, Error>) -> Void) {
        let urlRequest = makeURLRequest(url: url,
                                        httpMethod: httpMethod,
                                        parameters: parameters)
        let task = urlSession
            .dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    let error = NSError(
                        domain: Self.errorDomain,
                        code: httpResponse.statusCode,
                        userInfo: ["description": "Invalid status code"])
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    let error = NSError(
                        domain: Self.errorDomain,
                        code: -1,
                        userInfo: ["description": "Missing data"])
                    completion(.failure(error))
                    return
                }
                completion(.success(data))
            }
        task.resume()
    }
    
    private func makeURLRequest(url: URL,
                                httpMethod: HTTPMethod,
                                parameters: JSON?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        guard let parameters = parameters else {
            return urlRequest
        }
        
        switch httpMethod {
        case .GET:
            if let urlWithParameters = urlWithParameters(
                url: url, parameters: parameters) {
                urlRequest.url = urlWithParameters
            }
        }
        
        return urlRequest
    }
    
    private func urlWithParameters(url: URL, parameters: JSON) -> URL? {
        guard var urlComponents = URLComponents(
                url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.remove("+")
        let encodedString = encodedString(parameters: parameters,
                                          characterSet: characterSet)
        urlComponents.percentEncodedQuery = encodedString
        return urlComponents.url
    }
    
    private func encodedString(parameters: JSON,
                               characterSet: CharacterSet) -> String {
        parameters.compactMap { (key, value) -> String? in
            guard let encodedKey = key.addingPercentEncoding(
                    withAllowedCharacters: characterSet),
                  let stringValue = value as? CustomStringConvertible,
                  let encodedValue = stringValue.description
                    .addingPercentEncoding(withAllowedCharacters: characterSet)
            else {
                return nil
            }
            return "\(encodedKey)=\(encodedValue)"
        }.joined(separator: "&")
    }
}
