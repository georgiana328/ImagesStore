//
//  ItemViewController.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import UIKit

class ItemViewController: UIViewController {
    
    var item: Item!
    
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoritesNumber: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            loadViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
        switch Theme.shared.theme {
        case .dark:
            customNavigationBar.backgroundColor = UIColor.black
        case .light:
            customNavigationBar.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func didPressFavoriteButton(_ sender: Any) {
        if !DatabaseManager.shared.checkFavoriteImage(withId: item.id) {
            favoriteButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            item.favoriteNumber += 1
            DatabaseManager.shared.addFavoriteImage(withID: item.id)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorites"), for: .normal)
            item.favoriteNumber -= 1
            DatabaseManager.shared.removeFavoriteImage(withID: item.id)
        }
        favoritesNumber.text = "Favorites: \(item.favoriteNumber)"
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configure(withItem item: Item) {
        self.item = item
    }
    
    func loadViews() {
        userName.text = item.userName
        
        if DatabaseManager.shared.checkFavoriteImage(withId: item.id) {
            favoriteButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorites"), for: .normal)
        }
        
        tagsLabel.text = item.tags
        favoritesNumber.text = "Favorites: \(item.favoriteNumber)"
        
        if !item.userImageUrl.isEmpty {
            downloadImage(fromURL: item.userImageUrl, for: .user)
        }
        downloadImage(fromURL: item.imageUrl, for: .main)
    }
    
    func downloadImage(fromURL url: String, for usage: ImageUsage ) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    switch usage {
                    case .main: self.mainImage.image = image
                    case .user: self.userImage.image = image
                    }
                }
            }
            }.resume()
    }
}
