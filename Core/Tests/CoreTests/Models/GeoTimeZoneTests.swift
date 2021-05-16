//
//  GeoTimeZoneTests.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import XCTest
@testable import Core

final class GeoTimeZoneTests: XCTestCase {
    
    func testDecoding() throws {
        // Given
        let json = """
        {
            "lng":10.2,
            "countryCode":"AT",
            "timezoneId":"Europe/Vienna",
            "countryName":"Austria",
            "time":"2021-05-16 14:02",
            "lat":47.01
        }
        """
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        // When
        let sut = try decoder.decode(GeoTimeZone.self, from: data)
        
        // Then
        XCTAssertEqual(sut.id, "Europe/Vienna")
        XCTAssertEqual(sut.countryName, "Austria")
        XCTAssertEqual(sut.countryCode, "AT")
        XCTAssertEqual(sut.latitude, 47.01)
        XCTAssertEqual(sut.longitude, 10.2)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute], from: sut.time)
        XCTAssertEqual(components.year, 2021)
        XCTAssertEqual(components.month, 5)
        XCTAssertEqual(components.day, 16)
        XCTAssertEqual(components.hour, 14)
        XCTAssertEqual(components.minute, 2)
    }
}
