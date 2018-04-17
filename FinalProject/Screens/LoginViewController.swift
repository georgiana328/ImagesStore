//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 07/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin

class LoginViewController: UIViewController {

    @IBOutlet var loginView: UIView!
    
    var userData : [String : AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        //adding it to view
        view.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    self.userData = result as? [String : AnyObject]
                    print(result!)
                    print(self.userData as Any)
                }
            })
        }
    }
    
    func goToTabController() {
        if let tabViewController = storyboard?.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController {
            tabViewController.configure(withData: userData)
            present(tabViewController, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
        print(error)
        case .cancelled:
        print("User cancelled login.")
        case .success(_, _, _):
        self.getFBUserData()
        
        if !DatabaseManager.shared.checkIfUserExists() {
            DatabaseManager.shared.createFavoriteImagesForUser()
        }
        
        goToTabController()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) { }
}

    

