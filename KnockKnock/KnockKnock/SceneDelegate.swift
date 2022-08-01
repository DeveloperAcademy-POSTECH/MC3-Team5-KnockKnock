//
//  SceneDelegate.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard
    let passcodeViewController = PasscodeViewController()
    let keychainManager = KeychainManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // window = 화면 그 자체
        // scene = 화면 객체
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navVC = UINavigationController(rootViewController: RoomViewController())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        let isUnlock = userDefaults.bool(forKey: "isUnLock")
        print(isUnlock)
        if !isUnlock {
            self.userDefaults.set(true, forKey: "isUnLock")
            print(userDefaults.bool(forKey: "isUnLock"))
            let topMostViewController = UIApplication.shared.topMostViewController()
            
            if !(topMostViewController is PasscodeViewController) {
                let isPasscodeView = keychainManager.getItem(key: "passcode") == nil ? false : true
                if isPasscodeView {
                    passcodeViewController.passcodeMode = .pass
                    passcodeViewController.modalPresentationStyle = .overFullScreen
                    topMostViewController?.present(passcodeViewController, animated: false)
                    passcodeViewController.biometry()
                }
            } else {
                
                passcodeViewController.biometry()
            }
        }
    }
    


    func sceneWillResignActive(_ scene: UIScene) {
        passcodeViewController.passcodes.removeAll()
        passcodeViewController.update()
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        self.userDefaults.set(false, forKey: "isUnLock")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

