//
//  MainTabBarController.swift
//  ARTISTACK
//
//  Created by 임영준 on 2023/08/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBarItemImageInsets()
        self.tabBar.tintColor = .white
    }
}

extension MainTabBarController {
    func setTabBarItemImageInsets() {
        viewControllers?.forEach {
            if $0.tabBarItem.title == nil {
                $0.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
    
    private func setViewControllers() {
        let homeVC = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.home.image,
            selectedImage: Tab.home.selectedImage
        )
        homeNavigationController.navigationBar.isHidden = true
        

        let profileVC = ProfileViewController()
        let myPageNavigationController = UINavigationController(rootViewController: profileVC)
        myPageNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.profile.image,
            selectedImage: Tab.profile.selectedImage
        )

        super.setViewControllers([
            homeNavigationController,
            myPageNavigationController
        ], animated: true)
    }
}


