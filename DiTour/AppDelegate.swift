//
//  AppDelegate.swift
//  DiTour
//
//  Created by Pelaia II, Tom on 9/18/14.
//  Copyright (c) 2014 UT-Battelle ORNL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var lobbyModel = ILobbyModel()
	var presenter = ILobbyPresenter()


	override init() {
		self.lobbyModel.presentationDelegate = self.presenter;

		super.init()

		println( "app delegate init..." )
	}


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.

		UIApplication.sharedApplication().idleTimerDisabled = true;

		self.propagateLobbyModel( self.window?.rootViewController )

		return true
	}


	func propagateLobbyModel( optViewController:UIViewController? ) {
		if let viewController = optViewController {
			if let modelContainer = viewController as? ILobbyModelContainer {
				modelContainer.setLobbyModel( self.lobbyModel )
			}

			for subController in viewController.childViewControllers {
				self.propagateLobbyModel( subController as? UIViewController )
			}
		}
	}


	func application( application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void ) {
		self.lobbyModel.handleEventsForBackgroundURLSession( identifier, completionHandler: completionHandler );
	}


	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}


	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		self.lobbyModel.performShutdown()
	}


	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}


	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		self.presenter.updateConfiguration()
		self.lobbyModel.play()
	}


	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		self.lobbyModel.performShutdown()
	}
	
	
}
