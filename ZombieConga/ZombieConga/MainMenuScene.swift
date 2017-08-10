//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by 李森 on 2017/8/10.
//  Copyright © 2017年 李森. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        let background: SKSpriteNode = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: self.size.width/2.0, y: self.size.height/2.0)
        self.addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTapped()
    }
    
    fileprivate func sceneTapped() {
        let gameScene: GameScene = GameScene(size: CGSize(width: 2048, height: 1536))
        gameScene.scaleMode = self.scaleMode
        let transition: SKTransition = SKTransition.doorway(withDuration: 1.5)
        view?.presentScene(gameScene, transition: transition)
    }
}
