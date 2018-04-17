//
//  SettingsViewController.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var keywordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyword = UserDefaults.standard.value(forKey: "keyword")
        keywordLabel.text = "Current keyword is \(String(describing: keyword!))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressChangeKeywordButton(_ sender: Any) {
        if (keywordTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Alert", message: "Keyword cannot be empty", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            return
        }
        UserDefaults.standard.set(keywordTextField.text!, forKey: "keyword")
        UserDefaults.standard.set(false, forKey: "imageExists")
    }
}

