//
//  MockAPIClient.swift
//  RickAndMortyAppTests
//
//  Created by Tarsem Singh on 16/11/22.
//

import XCTest
@testable import RickAndMortyApp

final class MockAPIClient: APIClient {
    
    
    
    private(set) var fetchDecodedDataCount = 0
    private(set) var fetchDecodedDataUrl = ""
    private(set) var fetchDecodedDataCompletionHandler: Any?
    
    private(set) var fetchDataCount = 0
    private(set) var fetchDataUrl = ""
    private(set) var fetchDataCompletionHandler: Any?
    
    func fetchDecodedData<T>(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<T, RickAndMortyApp.APIError>) -> Void) where T : Decodable {
        fetchDecodedDataCount += 1
        self.fetchDecodedDataUrl = urlPath
        self.fetchDecodedDataCompletionHandler = completionHandler
    }
    
    func fetchData(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<Data, RickAndMortyApp.APIError>) -> Void) -> URLSessionDataTask? {
        fetchDataCount += 1
        self.fetchDataUrl = urlPath
        self.fetchDataCompletionHandler = completionHandler
        return MockURLSessionDataTask()
    }
    func fetchDataWithUrl(_ url: String, _ completionHandler: @escaping (Result<Data, RickAndMortyApp.APIError>) -> Void) -> URLSessionDataTask? {
        fetchDataCount += 1
        self.fetchDataUrl = url
        self.fetchDataCompletionHandler = completionHandler
        return MockURLSessionDataTask()
    }
}
