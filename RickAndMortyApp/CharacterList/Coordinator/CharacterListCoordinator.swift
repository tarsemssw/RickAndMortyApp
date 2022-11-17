//
//  CharacterListCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController{get set}
    func start()
}

final class CharacterListCoordinator : Coordinator{
    
    
    // MARK: Enums
    
    private enum Identifier{
        static let name = "Main"
        static let characterListViewController = "CharacterListViewController"
    }
    
    // MARK: Properties
    
    var navigationController: UINavigationController
    
    // MARK: Initialisers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Methods
    
    func start() {
        let characterListViewController = UIStoryboard(name: Identifier.name, bundle: nil).instantiateViewController(identifier: Identifier.characterListViewController) as CharacterListViewController
        characterListViewController.presenter = CharacterListPresenter(display: characterListViewController)
        navigationController.pushViewController(characterListViewController, animated: false)
    }
}
