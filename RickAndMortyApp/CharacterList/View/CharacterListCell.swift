//
//  CharacterListCell.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

class CharacterListCell: UITableViewCell {
    
    // MARK: Properties
    
    weak var cellItem: CharacterCellItem?
    
    // MARK: Outlets
    
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var episodes: UILabel!
    
    
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK:- Methods

    func configure(cellItem: CharacterCellItem){
        self.cellItem = cellItem
        name.text = cellItem.character.name
        episodes.text = "\(cellItem.character.episode.count) episodes"
        cellItem.loadImage {[weak self] image in
            self?.characterImageView.image = image
        }
    }
}
