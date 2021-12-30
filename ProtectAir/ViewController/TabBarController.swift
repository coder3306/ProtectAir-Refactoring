//
//  TabBarController.swift
//  ProtectAir
//
//  Created by 정성규 on 2021/09/12.
//

import UIKit

class TabBarController: UITabBarController {
    static let shared = TabBarController()
    func setTabbarBackgroundColor() {
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
    }
}
