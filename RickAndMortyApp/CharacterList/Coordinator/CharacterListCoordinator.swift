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
protocol CharacterListCoordinating: AnyObject {
    func didSelectCharacter(character: Character)
}


final class CharacterListCoordinator : Coordinator{
    
    
    // MARK: Enums
    
    private enum Identifier{
        static let name = "Main"
        static let characterListViewController = "CharacterListViewController"
        static let characterDetailViewController = "CharacterDetailViewController"
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
        characterListViewController.presenter = CharacterListPresenter(display: characterListViewController,coordinator: self)
        navigationController.pushViewController(characterListViewController, animated: false)
    }
    func navigateToDetailViewController(character: Character){
        let characterDetailViewController = UIStoryboard(name: Identifier.name, bundle: nil).instantiateViewController(identifier: Identifier.characterDetailViewController) as CharacterDetailViewController
        characterDetailViewController.presenter = CharacterDetailPresenter(display: characterDetailViewController, coordinator: CharacterDetailCoordinator(navigationController: navigationController))
        characterDetailViewController.character = character
        navigationController.pushViewController(characterDetailViewController, animated: true)
    }
}

extension CharacterListCoordinator : CharacterListCoordinating{
    func didSelectCharacter(character: Character) {
        navigateToDetailViewController(character: character)
    }
}

