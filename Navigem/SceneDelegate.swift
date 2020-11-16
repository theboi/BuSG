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
        
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

