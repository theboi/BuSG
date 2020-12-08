//
//  SceneDelegate.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        (UIApplication.shared.delegate as! AppDelegate).window = window
        window?.windowScene = windowScene
        
        let mainViewController = MainViewController()
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

