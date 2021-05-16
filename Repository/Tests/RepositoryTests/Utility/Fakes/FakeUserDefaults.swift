//
//  FakeUserDefaults.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation

final class FakeUserDefaults: UserDefaults {
    
    private(set) var setValueCalled = false
    private(set) var setValueValue: Any?
    private(set) var setValueKey: String?
    override func setValue(_ value: Any?, forKey key: String) {
        setValueValue = value
        setValueKey = key
        setValueCalled = true
    }
    
    private(set) var dataForKeyCalled = false
    private(set) var dataForKeyKey: String?
    var dataForKeyStubData: Data?
    override func data(forKey defaultName: String) -> Data? {
        dataForKeyKey = defaultName
        dataForKeyCalled = true
        return dataForKeyStubData
    }
}
