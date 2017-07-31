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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0.0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0.0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000.0) milliseconds since last update")
        
//        zombie.position = CGPoint(x: zombie.position.x+8.0, y: zombie.position.y)
//        moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0.0))
        moveSprite(sprite: zombie, velocity: velocity)
        
        boundsCheckZombie()
    }
    
    func sceneTouched(touchLocation: CGPoint) {
        moveZombieToward(location: touchLocation)
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x*CGFloat(dt), y: velocity.y*CGFloat(dt))
        print("amount to move \(amountToMove)")
        
        sprite.position = CGPoint(x: sprite.position.x+amountToMove.x, y: sprite.position.y+amountToMove.y)
    }
    
    func moveZombieToward(location: CGPoint) {
        let offset = CGPoint(x: location.x-zombie.position.x, y: location.y-zombie.position.y)
        let length = sqrt(Double(offset.x*offset.x + offset.y*offset.y))
        let direction = CGPoint(x: offset.x/CGFloat(length), y: offset.y/CGFloat(length))
        velocity = CGPoint(x: direction.x*zombieMovePointsPerSec, y: direction.y*zombieMovePointsPerSec)
    }
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint.zero
        let topRight = CGPoint(x: size.width, y: size.height)
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
}
