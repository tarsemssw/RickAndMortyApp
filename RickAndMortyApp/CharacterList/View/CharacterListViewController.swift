//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

import UIKit

protocol CharacterListPresenting {
    func viewDidLoad()
    func searchCharacterByName(name:String)
    func didSelectCharacter(characterCellItem: CharacterCellItem)
}

final class CharacterListViewController: UIViewController {
    
    // MARK: Private enums
    
    enum Constant{
        static let cellIdentifier = "CharacterListCell"
    }
    
    // MARK:- Properties
    
    var presenter: CharacterListPresenting!
    // MARK: Private
    
    var cellItems: [CharacterCellItem] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: Constant.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier)
            tableView.keyboardDismissMode = .onDrag
        }
    }
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDatalabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!{
        didSet{
            indicator.hidesWhenStopped = true
        }
    }
    @IBOutlet var navigationBarTitle: UILabel!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    // MARK: @IBAction
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        searchBarBeginEditing()
    }
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    
   
}

// MARK: CharacterListDisplaying

extension CharacterListViewController: CharacterListDisplaying{
    func showIndicator(_ shouldShow: Bool) {
        shouldShow ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    func showNoDataView(with message: String) {
        tableView.isHidden = true
        noDataView.isHidden = false
        self.noDatalabel.text = message
    }
    
    func show(list: [CharacterCellItem]) {
        tableView.isHidden = false
        noDataView.isHidden = true
        cellItems = list
    }
    
    func show(screenTitle: String) {
        self.navigationBarTitle.text = screenTitle
        self.navigationItem.titleView = navigationBarTitle
        self.navigationItem.rightBarButtonItem = searchButton
    }
}

