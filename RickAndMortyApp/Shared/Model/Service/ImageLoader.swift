//
//  ImageLoader.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import Foundation

protocol ImageLoading {
    func load(urlPath: String, completionHandler: @escaping ((Data) -> Void))
    func cancel(urlPath: String)
}

final class ImageLoader: ImageLoading{
    
    // MARK:- Properties
    
    private var apiClient: APIClient
    private var cache: [String : Data] = [:]
    private var ongoingTasks: [String : URLSessionDataTask] = [:]
    
    // MARK:- Initializer
    
    init(apiClient: APIClient = APIClientImplementation()) {
        self.apiClient = apiClient
    }
    
    // MARK: Methods
    
    func load(urlPath: String, completionHandler: @escaping ((Data) -> Void)){
//        guard let imagePath = URLComponents(string: urlPath)?.path else{return}
        
        if let data = cache[urlPath]{
            completionHandler(data)
            return
        }
        
        
       let task = apiClient.fetchDataWithUrl(urlPath) {[weak self] result in
        self? .ongoingTasks.removeValue(forKey: urlPath)
        
            switch result{
            case .success(let data):
                self?.cache[urlPath] = data
                completionHandler(data)
            case .failure(_):
                break
            }
        }
        ongoingTasks[urlPath] = task
        task?.resume()
    }
    
    func cancel(urlPath: String){
        if let cancellableTask = ongoingTasks[urlPath]{
            cancellableTask.cancel()
            ongoingTasks.removeValue(forKey: urlPath)
        }
    }
}


