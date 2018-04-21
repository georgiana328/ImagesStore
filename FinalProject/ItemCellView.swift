//
//  ItemCellView.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import UIKit

enum ImageUsage {
    case user
    case main
}

protocol CellDelegate: class {
    func didChangeStateForCell(_ item: ItemCellView, toFavoriteState state: Bool)
}

class ItemCellView: UITableViewCell {
    var item: Item!
    var delegate: CellDelegate?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    func configure(model: Item) {
        self.item = model
        userName.text = model.userName
        
        if DatabaseManager.shared.checkFavoriteImage(withId: model.id) {
            favoriteButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorites"), for: .normal)
        }
        
        if !model.userImageUrl.isEmpty {
            downloadImage(fromURL: model.userImageUrl, for: .user)
        }
        downloadImage(fromURL: model.imageUrl, for: .main)
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
        delegate?.didChangeStateForCell(self, toFavoriteState: item.favorite)
    }
    
}
