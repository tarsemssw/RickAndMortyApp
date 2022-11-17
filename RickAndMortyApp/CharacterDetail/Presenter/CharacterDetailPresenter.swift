//
//  CharacterDetailPresenter.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

protocol CharacterDetailDisplaying: AnyObject {
    func show(image: UIImage)
    func show(character: Character)
}


final class CharacterDetailPresenter {
 
    
    // MARK: Properties
    
    // MARK: Private
    private var imageHandler: ((UIImage) -> Void)?

    private weak var display: CharacterDetailDisplaying?
    private weak var coordinator: CharacterDetailCoordinating?
    private var imageLoader: ImageLoading
    
    // MARK: Initialisers
    init(display: CharacterDetailDisplaying, coordinator: CharacterDetailCoordinating, imageLoader: ImageLoading = ImageLoader()){
        self.display = display
        self.coordinator = coordinator
        self.imageLoader = imageLoader
    }
    
    // MARK:- Methods
    
    // MARK: Private
    func loadImage(url:String, handler: @escaping (UIImage) -> Void){
        imageHandler = handler
        imageLoader.load(urlPath: url) { data in
            if let image = UIImage(data: data){
                self.display?.show(image: image)
                self.imageHandler?(image)
            }
            
        }
    }
}

// MARK:- Conformance

// MARK: CharacterListPresenting

extension CharacterDetailPresenter: CharacterDetailPresenting{
    func viewDidLoad(character: Character) {
        display?.show(character: character)
        loadImage(url: character.image) { image in}
    }
}

