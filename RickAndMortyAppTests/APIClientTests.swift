//
//  APIClientTests.swift
//  RickAndMortyAppTests
//
//  Created by Tarsem Singh on 16/11/22.
//

import XCTest
@testable import RickAndMortyApp

class APIClientTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var apiClient: APIClientImplementation!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockURLSession = MockURLSession()
        apiClient = APIClientImplementation(session: mockURLSession)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiClient = nil
        mockURLSession = nil
    }
    
    // MARK:- Tests
    
    func testFetchData() throws {
        // When
        apiClient.fetchData("/api/character", queryItems: nil) { (result) in
        }
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://rickandmortyapi.com/api/character")
    }
    
    func testFetchDataSuccess() throws {
        // Given
        let data = Data()
        var receivedData: Data?
        let testExpectation = expectation(description: #function)
        
        // When
        apiClient.fetchData("/api/character", queryItems: nil) { result in
            switch result{
            case .success(let data):
                receivedData = data
            default:
                break
            }
            testExpectation.fulfill()
        }
        mockURLSession.completionHandler?(data, nil)
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://rickandmortyapi.com/api/character")
        XCTAssertEqual(receivedData, data)
    }
    
    func testFetchDataFailure() throws {
        // Given
        let mockError = MockError()
        var receivedError: APIError?
        let testExpectation = expectation(description: #function)
        
        // When
        apiClient.fetchData("/api/character", queryItems: nil) { result in
            switch result{
            case .failure(let error):
                receivedError = error
            default:
                break
            }
            testExpectation.fulfill()
        }
        mockURLSession.completionHandler?(nil, mockError)
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://rickandmortyapi.com/api/character")
        XCTAssertEqual(receivedError, APIError.response)
    }
    
    func testFetchDecodedData() throws {
        // When
        apiClient.fetchDecodedData("/api/character", queryItems: nil) {(result: Result<APIResponse, APIError>) in }
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://rickandmortyapi.com/api/character")
    }
    
    func testFetchDecodedDataSuccess() throws {
        // Given
        let mockData = mockJsonString.data(using: .utf8)
        var receivedData: APIResponse?
        let testExpectation = expectation(description: #function)
        
        // When
        apiClient.fetchDecodedData("/api/character", queryItems: nil) {(result: Result<APIResponse, APIError>) in
            switch result{
            case .success(let characterList):
                receivedData = characterList
            default:
                break
            }
            testExpectation.fulfill()
        }
        mockURLSession.completionHandler?(mockData, nil)
        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://rickandmortyapi.com/api/character")
        
    }
    
    func testFetchDecodedDataFailure() throws {
        // Given
        var receivedError: APIError?
        let testExpectation = expectation(description: #function)
        
        // When
        apiClient.fetchDecodedData("/api/character", queryItems: nil) {(result: Result<APIResponse, APIError>) in
            switch result{
            case .failure(let error):
                receivedError = error
            default:
                break
            }
            testExpectation.fulfill()
        }
        mockURLSession.completionHandler?(nil, MockError())
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(mockURLSession.loadDataCallCount, 1)
        XCTAssertEqual(mockURLSession.url?.absoluteString, "https://rickandmortyapi.com/api/character")
        XCTAssertEqual(receivedError, APIError.response)
    }
}

// MARK:- Mocks

final class MockURLSession: URLSessionProtocol{
    private(set) var loadDataCallCount = 0
    private(set) var url: URL?
    private(set) var completionHandler: ((Data?, Error?) -> Void)?
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        loadDataCallCount += 1
        self.url = url
        self.completionHandler = completionHandler
        return MockURLSessionDataTask()
    }
}

final class MockError: Error{
}

private var mockJsonString = """
{
    "info": {
        "count": 826,
        "pages": 42,
        "next": "https://rickandmortyapi.com/api/character?page=2",
        "prev": null
    },
    "results": [
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
            },
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2",
                "https://rickandmortyapi.com/api/episode/3",
                "https://rickandmortyapi.com/api/episode/4",
                "https://rickandmortyapi.com/api/episode/5",
                "https://rickandmortyapi.com/api/episode/6",
                "https://rickandmortyapi.com/api/episode/7",
                "https://rickandmortyapi.com/api/episode/8",
                "https://rickandmortyapi.com/api/episode/9",
                "https://rickandmortyapi.com/api/episode/10",
                "https://rickandmortyapi.com/api/episode/11",
                "https://rickandmortyapi.com/api/episode/12",
                "https://rickandmortyapi.com/api/episode/13",
                "https://rickandmortyapi.com/api/episode/14",
                "https://rickandmortyapi.com/api/episode/15",
                "https://rickandmortyapi.com/api/episode/16",
                "https://rickandmortyapi.com/api/episode/17",
                "https://rickandmortyapi.com/api/episode/18",
                "https://rickandmortyapi.com/api/episode/19",
                "https://rickandmortyapi.com/api/episode/20",
                "https://rickandmortyapi.com/api/episode/21",
                "https://rickandmortyapi.com/api/episode/22",
                "https://rickandmortyapi.com/api/episode/23",
                "https://rickandmortyapi.com/api/episode/24",
                "https://rickandmortyapi.com/api/episode/25",
                "https://rickandmortyapi.com/api/episode/26",
                "https://rickandmortyapi.com/api/episode/27",
                "https://rickandmortyapi.com/api/episode/28",
                "https://rickandmortyapi.com/api/episode/29",
                "https://rickandmortyapi.com/api/episode/30",
                "https://rickandmortyapi.com/api/episode/31",
                "https://rickandmortyapi.com/api/episode/32",
                "https://rickandmortyapi.com/api/episode/33",
                "https://rickandmortyapi.com/api/episode/34",
                "https://rickandmortyapi.com/api/episode/35",
                "https://rickandmortyapi.com/api/episode/36",
                "https://rickandmortyapi.com/api/episode/37",
                "https://rickandmortyapi.com/api/episode/38",
                "https://rickandmortyapi.com/api/episode/39",
                "https://rickandmortyapi.com/api/episode/40",
                "https://rickandmortyapi.com/api/episode/41",
                "https://rickandmortyapi.com/api/episode/42",
                "https://rickandmortyapi.com/api/episode/43",
                "https://rickandmortyapi.com/api/episode/44",
                "https://rickandmortyapi.com/api/episode/45",
                "https://rickandmortyapi.com/api/episode/46",
                "https://rickandmortyapi.com/api/episode/47",
                "https://rickandmortyapi.com/api/episode/48",
                "https://rickandmortyapi.com/api/episode/49",
                "https://rickandmortyapi.com/api/episode/50",
                "https://rickandmortyapi.com/api/episode/51"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
    ]
}
"""
