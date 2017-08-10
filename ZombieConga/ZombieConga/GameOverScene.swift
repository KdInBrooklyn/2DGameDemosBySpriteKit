//
//  GameOverScene.swift
//  ZombieConga
//
//  Created by 李森 on 2017/8/8.
//  Copyright © 2017年 李森. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let isWon: Bool
    
    init(size: CGSize, won: Bool) {
        self.isWon = won
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        
        if (isWon) {
            background = SKSpriteNode(imageNamed: "YouWin")
            run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.playSoundFileNamed("win.wav", waitForCompletion: false)]))
        } else {
            background = SKSpriteNode(imageNamed: "YouLose")
            run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)]))
        }
        
        background.position = CGPoint(x: self.size.width/2.0, y: self.size.height/2.0)
        self.addChild(background)
        
        //More here
        let wait = SKAction.wait(forDuration: 3.0)
        let block = SKAction.run { 
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        
        self.run(SKAction.sequence([wait, block]))
    }
}
