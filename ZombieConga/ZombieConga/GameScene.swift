//
//  GameScene.swift
//  ZombieConga
//
//  Created by 李森 on 2017/8/1.
//  Copyright © 2017年 李森. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private let zombie: SKSpriteNode = SKSpriteNode(imageNamed: "zombie1")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.brown
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        background.zPosition = -1
        
        zombie.position = CGPoint(x: 400.0, y: 400.0)
        
        addChild(background)
        addChild(zombie)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = lastUpdateTime - currentTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        print("\(dt*1000)milliseconds since lastupdate")
        
        zombie.position = CGPoint(x: zombie.position.x+8.0, y: zombie.position.y)
    }
}
