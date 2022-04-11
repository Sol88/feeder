//
//  SceneDelegate.swift
//  feeder
//
//  Created by Виктор Заикин on 09.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	private lazy var mainCoordinator: Coordinator = MainCoordinator(parentCoordinator: nil)

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let scene = (scene as? UIWindowScene) else { return }

		self.window = UIWindow(windowScene: scene)
		self.window?.rootViewController = self.mainCoordinator.start()
		self.window?.makeKeyAndVisible()
	}
}
