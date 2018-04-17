//
//  CustomTabBarController.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class CustomTabBarController: UITabBarController {
    
    var userData : [String : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userData == nil {
            getFBUserData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
    }
    
    func configure(withData data: [String: AnyObject]?) {
        userData = data
        
        // save in userdefaults
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error != nil {
                    print(error as Any)
                }
                self.userData = result as? [String : AnyObject]
            })
        }
    }
}
