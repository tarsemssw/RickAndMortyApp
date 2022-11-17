//
//  ImageLoaderTests.swift
//  RickAndMortyAppTests
//
//  Created by Tarsem Singh on 16/11/22.
//


import XCTest
@testable import RickAndMortyApp

class ImageLoaderTests: XCTestCase {
    
    var mockAPIClient: MockAPIClient!
    var imageLoader: ImageLoader!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIClient = MockAPIClient()
        imageLoader = ImageLoader(apiClient: mockAPIClient)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        imageLoader = nil
        mockAPIClient = nil
    }

    func testLoad() throws {
        // When
        imageLoader.load(urlPath: "/api/character/avatar/1.jpeg") { _ in }
        
        // Then
        XCTAssertEqual(mockAPIClient.fetchDataCount, 1)
        XCTAssertEqual(mockAPIClient.fetchDataUrl, "/api/character/avatar/1.jpeg")
        XCTAssertTrue(mockAPIClient.fetchDataCompletionHandler is ((Result<Data, APIError>) -> ()))
    }
    
    func testLoadSuccess() throws {
        // Given
        let mockData = Data()
        var receivedData: Data?
        imageLoader.load(urlPath: "/api/character/avatar/1.jpeg") { data in
            receivedData = data
        }
        
        // When
        let completion = mockAPIClient.fetchDataCompletionHandler as? (Result<Data, APIError>) -> Void
        completion?(.success(mockData))
        
        // Then
        XCTAssertEqual(receivedData, mockData)
    }
    
    func testDataLoadFromCache() throws {
        // Given
        let mockData = Data()
        var receivedData: Data?
        imageLoader.load(urlPath: "/api/character/avatar/1.jpeg") { _ in }
        let completion = mockAPIClient.fetchDataCompletionHandler as? (Result<Data, APIError>) -> Void
        completion?(.success(mockData))
        
        // When
        imageLoader.load(urlPath: "/api/character/avatar/1.jpeg") { data in
            receivedData = data
        }
        
        // Then
        XCTAssertEqual(mockAPIClient.fetchDataCount, 1)
        XCTAssertEqual(receivedData, mockData)
    }
}
