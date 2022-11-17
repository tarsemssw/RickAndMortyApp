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
}

final class CharacterListViewController: UIViewController {
    
    // MARK: Private enums
    
    private enum Constant{
        static let cellIdentifier = "CharacterListCell"
    }
    
    // MARK:- Properties
    
    var presenter: CharacterListPresenting!
    // MARK: Private
    
    private var cellItems: [CharacterCellItem] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.register(UINib(nibName: Constant.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier)
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
    
    
    // MARK: Methods
    func searchCharacterByName(name:String){
        if name.count > 0{
            navigationBarTitle.text = "showing results for \"\(name)\""
            presenter.searchCharacterByName(name: name)
        }
    }
    
    func searchBarEndEditing(){
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
