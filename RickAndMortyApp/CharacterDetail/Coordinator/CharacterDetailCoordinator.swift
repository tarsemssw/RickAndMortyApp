//
//  CharacterDetailCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

protocol CharacterDetailCoordinating: AnyObject {
    
}


final class CharacterDetailCoordinator : Coordinator{
    
    // MARK: Properties
    
    var navigationController: UINavigationController
    
    // MARK: Initialisers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    // MARK: Methods
    func start() {
     
    }
}

extension CharacterDetailCoordinator : CharacterDetailCoordinating{
}


