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
    
    var lastTouchLocation: CGPoint?
    let zombieRotateRadiansPersec: CGFloat = 4.0*CGFloat(Double.pi)
    
    let playableRect: CGRect
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private let zombie: SKSpriteNode = SKSpriteNode(imageNamed: "zombie1")
    let zombieAnimation: SKAction
    fileprivate let catCollisionSound: SKAction = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    fileprivate let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    
    
    // MARK: - life cycle
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        playableRect = CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
        
        //添加纹理图片
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        
        textures.append(textures[2])
        textures.append(textures[1])
        zombieAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        
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
//        zombie.run(SKAction.repeatForever(zombieAnimation))
        
        //添加敌人节点
//        spawnEnemy()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnEnemy), SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnCats), SKAction.wait(forDuration: 1.0)])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
//        print("\(dt*1000)milliseconds since lastupdate")
        
//        zombie.position = CGPoint(x: zombie.position.x+8.0, y: zombie.position.y)
//        moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePerSec, y: 0.0))
        guard let location = lastTouchLocation else { return }
        if ((location-zombie.position).length() <= zombieMovePerSec*CGFloat(dt)) {
            zombie.position = location
            velocity = CGPoint.zero
            stopZombieAnimation()
        } else {
            //移动zombie
            moveSprite(sprite: zombie, velocity: velocity)
            //旋转zombie的角度
            rotateSprite(sprite: zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPersec)
        }
        
        //对zombie的位置进行边界检查
        boundsCheckZombie()
        
        //对屏幕上的精灵进行碰撞检测
//        checkCollisions()
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        sceneTouched(touchLocation: touchLocation)
    }
    
    // MARK: - private method
    fileprivate func spawnEnemy() {
//        let enemy = SKSpriteNode(imageNamed: "enemy")
//        enemy.position = CGPoint(x: size.width+enemy.size.width/2.0, y: size.height/2.0)
//        addChild(enemy)
//        
//        let moveMidAction = SKAction.moveBy(
//            x: -size.width/2-enemy.size.width/2,
//            y: -playableRect.height/2 + enemy.size.height/2,
//            duration: 1.0)
//        let moveAction = SKAction.moveBy(
//            x: -size.width/2-enemy.size.width/2,
//            y: playableRect.height/2 - enemy.size.height/2,
//            duration: 1.0)
//        let waitAction = SKAction.wait(forDuration: 1.0)
//        let logMessage = SKAction.run { 
//            print("reached bottom")
//        }
//        let reverseMid = moveMidAction.reversed()
//        let reverseAction = moveAction.reversed()
//        
////        let sequence = SKAction.sequence([moveMidAction, waitAction, logMessage, moveAction, reverseAction, logMessage, waitAction, reverseMid])
////        enemy.run(moveAction)
//        
//        let halfSequence = SKAction.sequence([moveMidAction, waitAction, logMessage, moveAction])
//        let sequence = SKAction.sequence([halfSequence, halfSequence.reversed()])
//        let repeatAction = SKAction.repeat(sequence, count: 2)
//        enemy.run(repeatAction)
        
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        enemy.position = CGPoint(
            x: size.width + enemy.size.width/2,
            y: CGFloat.random(
                min: playableRect.minY + enemy.size.height/2,
                max: playableRect.maxY - enemy.size.height/2))
        addChild(enemy)
        let actionMove =
            SKAction.moveTo(x: -enemy.size.width/2, duration: 2.0)
//        enemy.run(actionMove)
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    fileprivate func spawnCats() {
        let cat: SKSpriteNode = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX), y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        cat.setScale(0.0)
        addChild(cat)
        
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
//        let wait = SKAction.wait(forDuration: 1.0)
        
        cat.zRotation = -π / 6.0
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
//        let wiggleWait = SKAction.repeat(fullWiggle, count: 10)
        
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        
        let groupWait = SKAction.repeat(group, count: 10)
        
        let disappear = SKAction.scale(to: 0.0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
    
    fileprivate func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
//        let amountToMove = CGPoint(x: velocity.x*CGFloat(dt), y: velocity.y*CGFloat(dt))
//        sprite.position = CGPoint(x: sprite.position.x+amountToMove.x, y: sprite.position.y+amountToMove.y)
        
        let amountToMove = velocity*CGFloat(dt)
        sprite.position += amountToMove
    }
    
    fileprivate func moveZombieToward(location: CGPoint) {
        startZombieAnimation()
        
//        let offset = CGPoint(x: location.x-zombie.position.x, y: location.y-zombie.position.y)
//        let length = sqrt(Double(offset.x*offset.x + offset.y*offset.y))
//        let direction = CGPoint(x: offset.x/CGFloat(length), y: offset.y/CGFloat(length))
//        velocity = CGPoint(x: direction.x*zombieMovePerSec, y: direction.y*zombieMovePerSec)
        
        let offset = location-zombie.position
//        let length = offset.length()
//        let direction = offset*CGFloat(length)
        velocity = offset.normalized()*zombieMovePerSec
    }
    
    fileprivate func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
//        sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x)))
        
        sprite.zRotation = direction.angle
        
        let shortestAngle = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec*CGFloat(dt), abs(shortestAngle))
        sprite.zRotation += shortestAngle.sign()*amountToRotate
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
    
    fileprivate func startZombieAnimation() {
        if zombie.action(forKey: "animation") == nil {
            zombie.run(SKAction.repeatForever(zombieAnimation), withKey: "animation")
        }
    }
    
    fileprivate func stopZombieAnimation() {
        zombie.removeAction(forKey: "animation")
        run(catCollisionSound)
    }
    
    fileprivate func zombieHitCat(cat: SKSpriteNode) {
        cat.removeFromParent()
        run(enemyCollisionSound)
    }
    
    fileprivate func zombieHitEnemy(enemy: SKSpriteNode) {
        enemy.removeFromParent()
        run(SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false))
    }
    
    fileprivate func checkCollisions() {
        var hitCats: [SKSpriteNode] = []
        
        enumerateChildNodes(withName: "cat") { (node, _) in
            if node is SKSpriteNode {
                if node.frame.intersects(self.zombie.frame) {
                    hitCats.append(node as! SKSpriteNode)
                }
            }
        }
        
        for cat in hitCats {
            self.zombieHitCat(cat: cat)
        }
        
        var hitEnemys: [SKSpriteNode] = []
        enumerateChildNodes(withName: "enemy") { (node, _) in
            if node is SKSpriteNode {
                if node.frame.insetBy(dx: 20, dy: 20).intersects(
                    self.zombie.frame) {
                    hitEnemys.append(node as! SKSpriteNode)
                }
            }
        }
        
        for enemy in hitEnemys {
            self.zombieHitEnemy(enemy: enemy)
        }
        
    }
}
