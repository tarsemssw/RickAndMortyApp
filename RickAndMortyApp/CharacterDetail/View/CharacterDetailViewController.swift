//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

protocol CharacterDetailPresenting {
    func viewDidLoad(character:Character)
}


final class CharacterDetailViewController: UIViewController {
    
    
    
    
    // MARK:- Properties
    
    var presenter: CharacterDetailPresenting!
    
    var character: Character?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let character = character else{return}
        presenter.viewDidLoad(character: character)
    }
    
    
}

// MARK: CharacterDetailDisplaying

extension CharacterDetailViewController: CharacterDetailDisplaying{
    func show(image: UIImage) {
        self.image.image = image
    }
    func show(character: Character) {
        self.title = character.name
        name.text = character.name
        status.text = character.status
        species.text = character.species
        gender.text = character.gender
        location.text = character.location.name
    }
}

