//
//  CharacterCellItem.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit
protocol CharacterCellItemNotifier: AnyObject {
    func loadImage(url:String, cellItem: CharacterCellItem)
}

final class CharacterCellItem {
    
    // MARK: Properties
    
    var character: Character

    var loadImageNotifier: ((String, @escaping ((UIImage) -> Void)) -> Void)?
    var cancelImageNotifier: ((String) -> Void)?
    
    private var imageHandler: ((UIImage) -> Void)?
    
    
    // MARK: Initialisers
    
    init(character: Character) {
        self.character = character
    }
    
    
    // MARK: Methods
    
    func loadImage(handler: @escaping (UIImage) -> Void){
        imageHandler = handler
        handler(#imageLiteral(resourceName: "placeholder"))
        
        loadImageNotifier?(character.image){[weak self] image in
            self?.imageHandler?(image)
        }
    }
    
    func cancel(){
        cancelImageNotifier?(character.image)
        imageHandler = nil
    }
    
}
