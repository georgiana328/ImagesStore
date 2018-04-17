//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 07/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var items: [Item] = []
    var databaseManager = DatabaseManager.shared
    
    @IBOutlet var itemsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            itemsTableView.refreshControl = refreshControl
        } else {
            itemsTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshItemsData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Images Data ...", attributes: [:])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
        switch Theme.shared.theme {
        case .dark:
            itemsTableView.backgroundColor = UIColor.darkGray
        case .light:
            itemsTableView.backgroundColor = UIColor.white
        }
        itemsTableView.reloadData()
        
        checkKeyword()
    }
    
    @objc private func refreshItemsData(_ sender: Any) {
        // Fetch Items Data
        DispatchQueue.main.async {
            self.searchBar.text = ""
            self.items = self.databaseManager.getItems()
            self.itemsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func checkKeyword() {
        let keyword = UserDefaults.standard.value(forKey: "keyword")
        if keyword == nil {
            let alert = UIAlertController(title: "Welcome", message: "You have to set your keyword for images", preferredStyle: .alert)
            alert.addTextField { (textfield) in }
            let action = UIAlertAction(title: "Set", style: .default) { _ in
                UserDefaults.standard.set(alert.textFields![0].text, forKey: "keyword")
                self.checkExistentImages()
            }
            alert.addAction(action)
            self.tabBarController?.present(alert, animated: true, completion: nil)
        } else {
            checkExistentImages()
        }
    }
    
    func checkExistentImages() {
        
        if let existsImages = UserDefaults.standard.value(forKey: "imageExists") as? Bool {
            if !existsImages {
                let keyword = UserDefaults.standard.value(forKey: "keyword")
                ApiManager.shared.getImages(for: keyword as! String) { success, items  in
                    if !success {
                        print("\n\nFailed request\n")
                    }
                    self.databaseManager.saveItems(items)
                    UserDefaults.standard.set(true, forKey: "imageExists")
                    self.items = items
                    self.itemsTableView.reloadData()
                }
            } else {
                if (searchBar.text?.isEmpty)! {
                    items = databaseManager.getItems()
                } else {
                    items = databaseManager.searchItem(withName: searchBar.text!)
                }
                itemsTableView.reloadData()
            }
        } else {
            let keyword = UserDefaults.standard.value(forKey: "keyword")
            ApiManager.shared.getImages(for: keyword as! String) { success, items  in
                if !success {
                    print("\n\nFailed request\n")
                }
                self.databaseManager.saveItems(items)
                UserDefaults.standard.set(true, forKey: "imageExists")
                self.items = items
                self.itemsTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ItemCellView", for: indexPath) as? ItemCellView else {
            return UITableViewCell()
        }
        
        cell.configure(model: items[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewController = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        itemViewController.configure(withItem: items[indexPath.row])
        present(itemViewController, animated: true, completion: nil)
    }
}


extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        }
        items = databaseManager.searchItem(withName: searchText)
        itemsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        items = databaseManager.getItems()
        itemsTableView.reloadData()
    }
}

extension HomeViewController: CellDelegate {
    func didChangeStateForCell(_ item: ItemCellView, toFavoriteState state: Bool) {
        let indexPath = itemsTableView.indexPath(for: item)
        items[(indexPath?.row)!].favorite = state
    }
}
