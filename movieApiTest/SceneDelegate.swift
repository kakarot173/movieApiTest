//
//  SceneDelegate.swift
//  movieApiTest
//
//  Created by Animesh Mohanty on 25/05/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let tabController = mainTabBar()

        //setup a view controller from another storyboard
     

        //this tab will start from a storyboard of its own
       
        //this will setup another tab bar but from a view controller only if you    want to setup things programmatically
        let collectionVc1 = CollectionViewController()
        let collectionVc2 = CollectionViewController()

        //setup the tab bar elements with the icons, name and initial view controllers
        let vcData: [(UIViewController, UIImage, String)] = [
            (collectionVc1, UIImage(named: "icon1")!, "1"),
            (collectionVc2, UIImage(named: "rate1")!, "2")
        ]

        let vcs = vcData.map { (vc, image, title) -> UINavigationController in
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem.image = image
            nav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            nav.tabBarItem.tag = Int(title) ?? 0
            nav.navigationBar.isTranslucent = true
            nav.navigationBar.tintColor = .darkGray

            nav.navigationBar.barTintColor = .darkGray
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.backgroundColor = UIColor(red: 246/255 , green: 193/255, blue: 173/255, alpha: 0.8)

            
            return nav
        }

        //customize tab bar
        tabController.viewControllers = vcs

        tabController.tabBar.barTintColor = .brown

        tabController.tabBar.tintColor = .brown
        tabController.tabBar.backgroundImage = UIImage()
        tabController.tabBar.shadowImage = UIImage()
        tabController.tabBar.isTranslucent = true
        
        tabController.tabBar.backgroundColor = UIColor(red: 242/255 , green: 204/255, blue: 152/255, alpha: 1)
        
     
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()

        //tab bar comes with a nav bar. here is how to customize i

       


    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

