//
//  FlickrCVC.swift
//  PhotoApp
//
//  Created by David Vallas on 5/6/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit
import DVNetwork

public class PersonTVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var persons: [Person] = []
    var searchedPersons: [Person] = []
    
    fileprivate let debug = true
    fileprivate let reuseIdentifier = "PersonCell"
    fileprivate var isSearching = false
    fileprivate var detailVC: UIViewController!
    
    // MARK: - View Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Add refresh control
        let rc = UIRefreshControl()
        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
        rc.attributedTitle = NSAttributedString(string: title)
        rc.addTarget(self, action: #selector(refreshModel), for: .primaryActionTriggered)
        tableView?.refreshControl = rc
        
        // Add Title
        self.title = "Characters"
        
        // Capture Detail View Controller
        detailVC = splitViewController?.viewControllers.last
        
        // Delegate Searchbar
        searchBar.delegate = self
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we haven't already, kick off initial photo request.
        if persons.count == 0 {
            updateModel()
        }
    }
    
    // MARK: - Private Functions
    
    /// Refreshes the model.  If user is using app at later day, they simply need to pull down to refresh.
    @objc fileprivate func refreshModel() {
        updateModel()
    }
    
    /// Adds persons to persons model. 
    fileprivate func updateModel() {
        PersonNetwork.getPersons() { [weak self] (result: DVResult<[Person]>) in
            switch result {
            case let .value(result):
                self?.persons = result
                self?.tableView?.refreshControl?.endRefreshing()
                self?.tableView?.reloadData()
            case let .error(error):
                self?.present(error.alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITableViewViewDataSource
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedPersons.count : persons.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PersonCell
        let person = isSearching ? searchedPersons[indexPath.row] : persons[indexPath.row]
        cell.name.text = person.name
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = isSearching ? searchedPersons[indexPath.row] : persons[indexPath.row]
        if let pvc = detailVC as? PersonVC { pvc.person = person }
        splitViewController?.showDetailViewController(detailVC, sender: nil)
        splitViewController?.toggleRootView() // will dismissn (animate removal) the root view controller from an iPad
    }
    
    // MARK: - UISearchBarDelegate
    
    func updateSearch(_ searchText: String) {
        // determine which array we will use in tableview
        if searchText == "" {
            isSearching = false
        } else {
            isSearching = true
            searchedPersons = persons.filter { $0.name.contains(searchText) || $0.description.contains(searchText) }
        }
        // reload tableview data
        tableView.reloadData()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearch(searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        updateSearch("")
        searchBar.showsCancelButton = false
    }
}
