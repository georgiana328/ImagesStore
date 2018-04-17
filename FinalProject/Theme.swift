//
//  Theme.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import UIKit

enum ApplicationTheme {
    case dark
    case light
}

class Theme {
    private init() { }
    static var shared = Theme()
    
    var theme: ApplicationTheme = .light
}

extension UIViewController {
    func setTheme() {
        let theme = Theme.shared.theme
        switch theme {
        case .dark:
            view.backgroundColor = UIColor.darkGray
            tabBarController?.tabBar.backgroundColor = UIColor.black
            navigationController?.navigationBar.backgroundColor = UIColor.black
        case .light:
            view.backgroundColor = UIColor.white
            tabBarController?.tabBar.backgroundColor = UIColor.white
            navigationController?.navigationBar.backgroundColor = UIColor.white
        }
    }
}
