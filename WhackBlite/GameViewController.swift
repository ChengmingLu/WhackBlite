//
//  GameViewController.swift
//  WhackBlite
//
//  Created by Fumlar on 2017-06-04.
//  Copyright © 2017 Fumlar. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        //NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        if let view = self.view as! SKView? {
            
            if (!UserDefaults.standard.bool(forKey: "appFirstLaunched")) {
                UserDefaults.standard.set(true, forKey: "appFirstLaunched")
                UserDefaults.standard.synchronize()
                
                if let scene = SKScene(fileNamed: "GameHint") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                }
                
            } else {
                if let scene = SKScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
            
                    // Present the scene
                    view.presentScene(scene)
                }
            }
            // Load the SKScene from 'GameScene.sks'
            view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }

    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                //self.presentViewController(viewController!, animated: true, completion: nil)
                self.present(viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().isAuthenticated))
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
}
