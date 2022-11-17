//
//  CharacterListPresenter.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

protocol CharacterListDisplaying: AnyObject {
    func show(screenTitle: String)
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

}

// MARK:- Conformance

// MARK: CharacterListPresenting

extension CharacterListPresenter: CharacterListPresenting{
    func viewDidLoad() {
        display?.show(screenTitle: Constant.screenTitle)
    }
}

