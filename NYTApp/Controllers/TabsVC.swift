//
//  ViewController.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 16.05.2023.
//

import UIKit


class TabsViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpTabs()
    }
    
    
    private func setUpTabs(){
        let SharedVC = MostSharedVC()
        let EmailedVC = MostEmailedVC()
        let ViewedVC = MostViewedVC()
        let FavoriteVC = FavoriteVC()
        
        let nav1 = UINavigationController(rootViewController: ViewedVC )
        let nav2 = UINavigationController(rootViewController: EmailedVC)
        let nav3 = UINavigationController(rootViewController: SharedVC)
        let nav4 = UINavigationController(rootViewController: FavoriteVC)
        
        ViewedVC.title = "Most Viewed"
        EmailedVC.title = "Most Emailed"
        SharedVC.title = "Most Shared"
        FavoriteVC.title = "Favorite"
        
        
        nav1.tabBarItem = UITabBarItem(title: "Most Viewed",
                                       image: nil,
                                       tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Most Emailed",
                                       image: nil,
                                       tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Most Shared",
                                       image: nil,
                                       tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Favorite",
                                       image: nil,
                                       tag: 4)
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        
        

    }
    
}


