//
//  CharacterListViewController+TableView.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit


// MARK: UITableViewDataSource

extension CharacterListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath) as! CharacterListCell
        cell.configure(cellItem: cellItems[indexPath.row])
        return cell
    }
    
}

// MARK: UITableViewDelegates

extension CharacterListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarEndEditing()
        let characterCellItem = cellItems[indexPath.row]
        presenter.didSelectCharacter(characterCellItem: characterCellItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
