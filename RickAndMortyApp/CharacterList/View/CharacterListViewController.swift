//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

protocol CharacterListPresenting {
    func viewDidLoad()
}

final class CharacterListViewController: UIViewController {
    
    // MARK:- Properties
    
    var presenter: CharacterListPresenting!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

}

// MARK: CharacterListDisplaying

extension CharacterListViewController: CharacterListDisplaying{
    func show(screenTitle: String) {
        self.title = screenTitle
    }
}
