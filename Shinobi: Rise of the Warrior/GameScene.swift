//
//  GameScene.swift
//  Shinobi: Rise of the Warrior
//
//  Created by Keegan Brown on 5/30/19.
//  Copyright © 2019 Keegan Brown. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Enemy : UInt32 = 0b1
    static let Star : UInt32 = 0b10
    static let CollisionDetector : UInt32 = 0b11
    
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    public var isGameOver = false //might need
    public var speedMod = 0.0
    
    let player = SKSpriteNode(imageNamed: "ninja")
    let heart1 = SKSpriteNode(imageNamed: "heart")
    let heart2 = SKSpriteNode(imageNamed: "heart")
    let heart3 = SKSpriteNode(imageNamed: "heart")
    //heart is really just a place holder. We will never see this image it will only be used for detection
    let collisionDetector = SKSpriteNode(imageNamed: "heart")
    let gameOver = SKSpriteNode(imageNamed: "gameOver")
    
    var lifeCount = 3
    
    override func didMove(to view: SKView) {
        
        //sets up SKView
        gameOver.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        gameOver.size = CGSize(width: 400, height: 300)
        gameOver.isHidden = true
        addChild(gameOver)
        
        backgroundColor = SKColor.white
        collisionDetector.size = CGSize(width: 1, height: 1000)
        collisionDetector.position = CGPoint(x: 0, y: 1)
        
        collisionDetector.physicsBody = SKPhysicsBody(rectangleOf: collisionDetector.size)
        collisionDetector.physicsBody?.isDynamic = true
        collisionDetector.physicsBody?.categoryBitMask = PhysicsCategory.CollisionDetector
        collisionDetector.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        collisionDetector.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        addChild(collisionDetector)
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        heart1.size = CGSize (width: 30, height: 30)
        heart1.position = CGPoint(x: 50, y: frame.height-50)
        addChild(heart1)
        heart2.size = CGSize (width: 30, height: 30)
        heart2.position = CGPoint(x: 85, y: frame.height-50)
        addChild(heart2)
        heart3.size = CGSize (width: 30, height: 30)
        heart3.position = CGPoint(x: 120, y: frame.height-50)
        addChild(heart3)
        //sets up physics and delegate
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        //adds 1 enemy per second
        
        //waits a bit for the compiler to catch up. Kind of a hacky fix.
        sleep (1)
        
        let infiniteAction = SKAction.repeatForever(SKAction.sequence([SKAction.run(addEnemy), SKAction.wait(forDuration: 1.0)]))
        
        if lifeCount == 0{
            //do nothing
        } else{
            run(infiniteAction)
        }
        
        //background music
        let backgroundMusic = SKAudioNode(fileNamed: "gameMusic.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func addEnemy(){
        
        
        if lifeCount != 0 {
            //creating an enemy sprite
            let enemy = SKSpriteNode(imageNamed: "enemy")
            let actualY = random(min: enemy.size.height / 2, max: size.height - enemy.size.height / 2)
            enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: actualY)
            //adds physics to sprite
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody?.isDynamic = true
            enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Star
            enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
            addChild(enemy)
            //moves enemy sprite
            print ("\(speedMod)")
            let actualDuration = random(min: CGFloat(4.0 - speedMod), max: CGFloat(6.0 - speedMod))
            let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: actualY), duration: TimeInterval(actualDuration))
            let actionMoveDone = SKAction.removeFromParent()
            enemy.run(SKAction.sequence([actionMove, actionMoveDone]))
        } else {
            removeAllActions()
            print ("GAME OVER")
        }
        
    }
    
    func starDidCollideWithEnemy(nodeA: SKSpriteNode, nodeB: SKSpriteNode){
        print("hit")
        if nodeA != collisionDetector{
            nodeA.removeFromParent()
        }
        if nodeB != collisionDetector{
            nodeB.removeFromParent()
        }
        
    }
    
    func enemyDidCollideWithCollisionDetector(){
        switch lifeCount{
        case 3:
            heart3.removeFromParent()
            lifeCount -= 1
        case 2:
            heart2.removeFromParent()
            lifeCount -= 1
        case 1:
            heart1.removeFromParent()
            lifeCount -= 1
            gameOver.isHidden = false
            isGameOver = true
        default:
            print ("Error")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if collisionDetector.physicsBody == secondBody || collisionDetector.physicsBody == firstBody{
            enemyDidCollideWithCollisionDetector()
        }
        if let enemy = firstBody.node as? SKSpriteNode,
            let star = secondBody.node as? SKSpriteNode{
            starDidCollideWithEnemy(nodeA: star, nodeB: enemy)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //star sound
        run(SKAction.playSoundFileNamed("pew.wav", waitForCompletion: false))
        
        //sets up star throw
        guard let touch = touches.first else{
            return
        }
        //creates star
        let touchLocation = touch.location(in: self)
        let star = SKSpriteNode(imageNamed: "star")
        star.position = player.position
        let offset = touchLocation - star.position
        if offset.x < 0{
            return
        }
        //adds physics to sprite
        star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width / 2)
        star.physicsBody?.isDynamic = true
        star.physicsBody?.categoryBitMask = PhysicsCategory.Star
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.usesPreciseCollisionDetection = true
        addChild(star)
        //sets up vector for star using VectorMath.swift
        let direction = offset.normalized()
        let shotDistance = direction * 1000
        let realDestination = shotDistance + star.position
        //creates the actions and runs them to move the star SKSprite
        let actionThrow = SKAction.move(to: realDestination, duration: 2.0)
        let actionThrowDone = SKAction.removeFromParent()
        star.run(SKAction.sequence([actionThrow, actionThrowDone]))
    }
    
    func random() -> CGFloat{
        //commented out code was giving some enemies locations outside of the frame.
        //return CGFloat.random(in: 0...5)
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}
