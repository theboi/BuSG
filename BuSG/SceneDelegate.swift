//
//  SceneDelegate.swift
//   BuSG
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
        
        checkForUpdates()
    }
    
    private func checkForUpdates() {
//        UserDefaults.standard.setValue(0, forKey: K.userDefaults.lastOpenedEpoch)
        let nowEpoch = Date().timeIntervalSince1970
        let lastOpenedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastOpenedEpoch)
        let lastUpdatedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastUpdatedEpoch)

        if lastOpenedEpoch == 0 {
            print("First Timer!")
            /// First time using app
            window?.rootViewController?.present(UINavigationController(rootViewController: SetupViewController()), animated: true)
        }
        let updateFrequency: Double = { () -> Double in
            switch UserDefaults.standard.integer(forKey: K.userDefaults.updateFrequency) {
            case 0: return 604800 // 1 week
            case 1: return 2629743 // 1 month
            default: return -999
            }
        }()
        if lastUpdatedEpoch+updateFrequency < nowEpoch && updateFrequency != -999 {
            /// Requires update of bus data
            print("UPDATING BUS DATA")
            ApiProvider.shared.updateStaticData() {
                UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastUpdatedEpoch)
            }
        }
        UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastOpenedEpoch)
        
        if UserDefaults.standard.bool(forKey: K.userDefaults.connectToCalendar) {
            EventProvider.shared.requestForCalendarAccess { (granted, error) in
                UserDefaults.standard.setValue(false, forKey: K.userDefaults.connectToCalendar)
                
                if error != nil || !granted {
                    let alert = UIAlertController(title: "Unable to access Calendar", message: error?.localizedDescription ?? "In order to access this feature, BuSG requires you to grant access to Calendar in Settings", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                        URL.open(webURL: UIApplication.openSettingsURLString)
                    }))
                    self.window?.rootViewController?.present(alert, animated: true)
                }
            }
        }
    }
}

