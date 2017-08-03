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
    
    let zombieMovePerSec: CGFloat = 180.0
    var velocity: CGPoint = CGPoint.zero
    
    let playableRect: CGRect
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private let zombie: SKSpriteNode = SKSpriteNode(imageNamed: "zombie1")
    
    // MARK: - life cycle
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        playableRect = CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        print("\(dt*1000)milliseconds since lastupdate")
        
//        zombie.position = CGPoint(x: zombie.position.x+8.0, y: zombie.position.y)
//        moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePerSec, y: 0.0))
        moveSprite(sprite: zombie, velocity: velocity)
        
        //对zombie的位置进行边界检查
        boundsCheckZombie()
        
        //旋转zombie的角度
        rotateSprite(sprite: zombie, direction: velocity)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    // MARK: - private method
    fileprivate func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
//        let amountToMove = CGPoint(x: velocity.x*CGFloat(dt), y: velocity.y*CGFloat(dt))
//        sprite.position = CGPoint(x: sprite.position.x+amountToMove.x, y: sprite.position.y+amountToMove.y)
        
        let amountToMove = velocity*CGFloat(dt)
        sprite.position += amountToMove
    }
    
    fileprivate func moveZombieToward(location: CGPoint) {
//        let offset = CGPoint(x: location.x-zombie.position.x, y: location.y-zombie.position.y)
//        let length = sqrt(Double(offset.x*offset.x + offset.y*offset.y))
//        let direction = CGPoint(x: offset.x/CGFloat(length), y: offset.y/CGFloat(length))
//        velocity = CGPoint(x: direction.x*zombieMovePerSec, y: direction.y*zombieMovePerSec)
        
        let offset = location-zombie.position
        let length = offset.length()
        let direction = offset*CGFloat(length)
        velocity = offset.normalized()*zombieMovePerSec
    }
    
    fileprivate func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
//        sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x)))
        
        sprite.zRotation = direction.angle
    }
    
    fileprivate func sceneTouched(touchLocation: CGPoint) {
        moveZombieToward(location: touchLocation)
    }
    
    fileprivate func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0.0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
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
    
    fileprivate func drawDebugPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = UIColor.purple
        shape.lineWidth = 5.0
        addChild(shape)
    }
}
