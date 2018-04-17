//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 07/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
        switch Theme.shared.theme {
        case .light:
            segmentedControl.selectedSegmentIndex = 1
        case .dark:
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func didPressLogoutButton(_ sender: Any) {
        FBSDKLoginManager().logOut()
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func didPressSettingsButton(_ sender: Any) {
        let settingsViewController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")
        present(settingsViewController!, animated: true, completion: nil)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            Theme.shared.theme = .dark
            setTheme()
            break
        case 1:
            Theme.shared.theme = .light
            setTheme()
            break
        default:
            break;
        }
    }
    
    func updateView() {
        let customTabBarController = tabBarController as! CustomTabBarController
        if customTabBarController.userData == nil {
            print("Cannot found userData")
            return
        }
        
        let imageData = customTabBarController.userData!["picture"]!["data"]! as! [String: AnyObject]
        
        downloadImage(fromURL: imageData["url"] as! String)
        nameLabel.text = customTabBarController.userData?["name"] as? String
        emailLabel.text = customTabBarController.userData?["email"] as? String
    }
    
    func downloadImage(fromURL url: String) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.profileImage.image = image
                }
            }
        }.resume()
    }
}
