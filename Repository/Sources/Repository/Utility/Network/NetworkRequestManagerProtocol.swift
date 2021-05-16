//
//  NetworkRequestManagerProtocol.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core

/// Defines the requirements for a network request manager.
protocol NetworkRequestManagerProtocol {
    
    /// Make a network request.
    /// - Parameters:
    ///   - url: The url for the request.
    ///   - httpMethod: The `HTTPMethod` for the request.
    ///   - parameters: The parameters for the request if any.
    ///   - modelType: The model type to decode.
    ///   - completion: Closure to be called with the result of making the request.
    func makeRequest<T: Model>(
        url: URL,
        httpMethod: HTTPMethod,
        parameters: JSON?,
        modelType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void)
}
