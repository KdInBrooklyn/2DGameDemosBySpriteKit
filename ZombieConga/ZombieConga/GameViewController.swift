//
//  GameViewController.swift
//  ZombieConga
//
//  Created by 李森 on 2017/8/1.
//  Copyright © 2017年 李森. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let skView = self.view as? SKView {
//            let gameScene = GameScene(size: CGSize(width: 2048, height: 1536))
//            gameScene.scaleMode = .aspectFill
            
            let mainScene = MainMenuScene(size: CGSize(width: 2048, height: 1536))
            mainScene.scaleMode = .aspectFill
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            
//            skView.presentScene(gameScene)
            skView.presentScene(mainScene)
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
