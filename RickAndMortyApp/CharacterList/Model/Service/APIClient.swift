//
//  APIClient.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

protocol URLSessionProtocol {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol{
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)-> URLSessionDataTask {
        return dataTask(with: url) { (data, _, error) in
            completionHandler(data, error)
        }
    }
}

final class APIClientImplementation: APIClient{
    
    // MARK:- Enums
    private enum Components {
        static let scheme = "https"
        static let host = "rickandmortyapi.com"
    }
    
    // MARK:- Properties
    
    // MARK: Private
    
    private var session: URLSessionProtocol!
    private var urlComponents = URLComponents()
    
    // MARK:- Initialisers
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        urlComponents.scheme = Components.scheme
        urlComponents.host = Components.host
    }
    
    // MARK:- Methods
    
    func fetchDecodedData<T: Decodable>(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<T, APIError>) -> Void){
        fetchData(urlPath,queryItems: queryItems) { (result) in
            switch result{
            case .success(let data):
                guard let response =  try? JSONDecoder().decode(T.self, from: data) else {
                    return completionHandler(.failure(APIError.response))
                }
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }?.resume()
    }
    
    @discardableResult func fetchData(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?{
        urlComponents.path = urlPath
        if let queryItems = queryItems{
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            completionHandler(.failure(APIError.request))
            return nil
        }
        return fetchDataWithUrl(url.absoluteString, completionHandler)
    }
    @discardableResult func fetchDataWithUrl(_ url: String, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?{
        
        guard let url = URL(string: url)else{
            completionHandler(.failure(APIError.request))
            return nil
        }
        
        return session.loadData(from: url) { data, error in
            let result:Result<Data, APIError> = self.getResult(data: data, error: error)
            DispatchQueue.main.async { completionHandler(result) }
        }
    }
    
    private func getResult(data: Data?, error: Error?) -> Result<Data, APIError>{
        guard let data = data else {
            return .failure(APIError.response)
        }
        return .success(data)
    }
}

enum APIError: Error{
    case request
    case response
}

