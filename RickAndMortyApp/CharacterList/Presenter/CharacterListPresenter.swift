//
//  CharacterListPresenter.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import Foundation
import UIKit

protocol CharacterListDisplaying: AnyObject {
    func show(screenTitle: String)
    func showIndicator(_ shouldShow: Bool)
    func showNoDataView(with message: String)
    func show(list: [CharacterCellItem])
}

protocol APIClient {
    func fetchDecodedData<T: Decodable>(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<T, APIError>) -> Void)
    @discardableResult func fetchData(_ urlPath: String, queryItems: [URLQueryItem]?, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?
    @discardableResult func fetchDataWithUrl(_ url: String, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?
}


final class CharacterListPresenter {
 
    // MARK: Enums
    
    // MARK: Private
    
    private enum Constant{
        static let screenTitle = "Characters"
    }
    
    private enum URLPath {
        static let characterList = "/api/character"
        static let paramName = "name"
    }
    
    private enum Message{
        static let emptyView = "Sorry! \n\n Could not find any characters. Please try again later."
        static let error = "Oops! \n\n There is some issue in loading characters. Please try again later."
        static let general = "Something went wrong!"
    }
    
    
    // MARK: Properties
    
    // MARK: Private
    
    private weak var display: CharacterListDisplaying?
    private var apiClient: APIClient!
    private var imageLoader: ImageLoading
    
    // MARK: Initialisers
    init(display: CharacterListDisplaying, apiClient: APIClient = APIClientImplementation(), imageLoader: ImageLoading = ImageLoader()){
        self.display = display
        self.apiClient = apiClient
        self.imageLoader = imageLoader
    }
    
    // MARK:- Methods
    
    // MARK: Private
    
    private func fetchCharacterList(){
        fetchData(urlPath: URLPath.characterList, queryItems: nil)
    }
    
    private func fetchData(urlPath: String, queryItems: [URLQueryItem]?){
        display?.showIndicator(true)
                
        apiClient.fetchDecodedData(urlPath, queryItems: queryItems) {[weak self] (result: Result<APIResponse, APIError>) in
            
            defer{
                self?.display?.showIndicator(false)
            }
            
            switch result{
            case .success(let response):
                self?.handleSuccesss(with: response.results)
                break
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    private func handleSuccesss(with characterList:[Character]){
        guard characterList.count > 0 else{
            
            self.display?.showNoDataView(with: Message.emptyView)
            return
        }
        
        let characterCellItems: [CharacterCellItem] = characterList.map(){ character -> CharacterCellItem in
            let characterCellItem = CharacterCellItem(character: character)
            characterCellItem.loadImageNotifier = { urlPath, displayImage  in
                self.imageLoader.load(urlPath: urlPath) { data in
                    if let image = UIImage(data: data){
                        displayImage(image)
                    }else{
                        print("failed")
                    }
                }
            }
            characterCellItem.cancelImageNotifier = { urlPath in
                self.imageLoader.cancel(urlPath: urlPath)
            }
          return characterCellItem
        }
        
        self.display?.show(list: characterCellItems)
    }
    
    private func handleError(_ error: APIError){
        var errorMessage: String
        switch error {
        case .request:
            errorMessage = Message.general
        case .response:
            errorMessage = Message.error
        }
        
        self.display?.showNoDataView(with: errorMessage)
    }

}

// MARK:- Conformance

// MARK: CharacterListPresenting

extension CharacterListPresenter: CharacterListPresenting{
    func viewDidLoad() {
        display?.show(screenTitle: Constant.screenTitle)
        fetchCharacterList()
    }
}

