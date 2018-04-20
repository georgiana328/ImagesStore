//
//  FavouritesViewController.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 07/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    var items: [Item] = []
    var databaseManager = DatabaseManager.shared
    
    @IBOutlet var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

        items = databaseManager.getFavoriteItems()
        itemsTableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.isEmpty {
            return 1
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if items.isEmpty {
            let cell = itemsTableView.dequeueReusableCell(withIdentifier: "NoFavoriteCell", for: indexPath)
                return cell
        }

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

extension FavoritesViewController: CellDelegate {
    func didChangeStateForCell(_ item: ItemCellView, toFavoriteState state: Bool) {
        let indexPath = itemsTableView.indexPath(for: item)
        items[(indexPath?.row)!].favorite = state
    }
}
