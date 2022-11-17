//
//  CharacterListViewController+Search.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit


extension CharacterListViewController{
    
    // MARK: Methods
    func searchCharacterByName(name:String){
        if name.count > 0{
            navigationBarTitle.text = "showing results for \"\(name)\""
            presenter.searchCharacterByName(name: name)
        }
    }
    
    func searchBarEndEditing(){
        
        let frame = searchBar.frame
        self.searchBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.searchBar.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        }, completion: {(_ finished: Bool) -> Void in
            self.searchBarHideEndedAnimating()
            self.searchBar.layoutIfNeeded()
        })
    }
    func searchBarHideEndedAnimating(){
        self.navigationItem.titleView = navigationBarTitle
        searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    func searchBarBeginEditing(){
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        if let cancelButton = self.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        let frame = searchBar.frame
        self.searchBar.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.searchBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }, completion: {(_ finished: Bool) -> Void in
            self.searchBar.layoutIfNeeded()
        })
    }
}

// MARK: UISearchBarDelegate

extension CharacterListViewController: UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarEndEditing()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            searchCharacterByName(name: searchText)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchCharacterByName(name: searchText)
        }
        searchBarEndEditing()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarEndEditing()
    }
}
