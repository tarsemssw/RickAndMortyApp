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
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDatalabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet var navigationBarTitle: UILabel!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!    
    
    // MARK: @IBAction
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.navigationItem.titleView = searchBar
    }
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

}

// MARK: CharacterListDisplaying

extension CharacterListViewController: CharacterListDisplaying{
    func show(screenTitle: String) {
        self.navigationBarTitle.text = screenTitle
        self.navigationItem.titleView = navigationBarTitle
        self.navigationItem.rightBarButtonItem = searchButton
    }
}
