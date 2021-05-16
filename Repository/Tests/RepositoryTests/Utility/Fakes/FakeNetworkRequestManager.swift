//
//  FakeNetworkRequestManager.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core
@testable import Repository

final class FakeNetworkRequestManager: NetworkRequestManagerProtocol {
    
    var stubResponse: Result<Model, Error> = .failure(NSError())
    private(set) var makeRequestCalled = false
    private(set) var makeRequestModelType: Model.Type? = nil
    func makeRequest<T>(
        url: URL,
        httpMethod: HTTPMethod,
        parameters: JSON?,
        modelType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) where T : Model {
        makeRequestCalled = true
        makeRequestModelType = modelType
        switch stubResponse {
        case .success(let model):
            guard let model = model as? T else {
                completion(.failure(NSError()))
                return
            }
            completion(.success(model))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
