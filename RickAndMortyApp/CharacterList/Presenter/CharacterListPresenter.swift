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

final class CharacterListPresenter {
 
    // MARK: Enums
    
    // MARK: Private
    
    private enum Constant{
        static let screenTitle = "Characters"
    }
    
    // MARK: Properties
    
    // MARK: Private
    
    private weak var display: CharacterListDisplaying?
    
    // MARK: Initialisers
    init(display: CharacterListDisplaying){
        self.display = display
    }
    
    // MARK:- Methods
    
    // MARK: Private
    
    private func fetchCharacterList(){
        display?.showIndicator(true)
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

