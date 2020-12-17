//
//   BuSGTests.swift
//   BuSGTests
//
//  Created by Ryan The on 16/11/20.
//

import XCTest
@testable import BuSG

class BuSGTests: XCTestCase {

    // test_methodName_unitOfWork_expectedBehavior
    func test_initStringWithQueries_url_generateUrl() {
        // Given
        let urlWithQueries = URL(string: "https://ryanthe.com", with: [
            URLQueryItem(name: "test", value: "url"),
            URLQueryItem(name: "in", value: "swift"),
            URLQueryItem(name: "is", value: "fun"),
        ])
        // When
        // Then
        XCTAssertEqual(urlWithQueries, URL(string: "https://ryanthe.com?test=url&in=swift&is=fun"))
    }

}
