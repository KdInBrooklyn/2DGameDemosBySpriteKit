//
//  GameScene.swift
//  SpriteDemo
//
//  Created by 李森 on 2017/7/31.
//  Copyright © 2017年 Li Sen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.brown
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        background.zPosition = -1
        addChild(background)
        
        zombie.position = CGPoint(x: 400.0, y: 400.0)
//        zombie.setScale(2.0)
        addChild(zombie)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0.0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0.0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000.0) milliseconds since last update")
        
        zombie.position = CGPoint(x: zombie.position.x+8.0, y: zombie.position.y)
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x*CGFloat(dt), y: velocity.y*CGFloat(dt))
        print("amount to move \(amountToMove)")
        
        sprite.position = CGPoint(x: sprite.position.x+amountToMove.x, y: sprite.position.y+amountToMove.y)
    }
}
