//
//  GameScene.swift
//  JamTanks
//
//  Created by Macrinici Dan on 12/19/15.
//  Copyright (c) 2015 Swagler Enterprise. All rights reserved.
//

import SpriteKit
import Cocoa
import Darwin
let pi = M_PI

//We have two different sprite types which can collide. The Hero sprite and the bullets. I've created them outside the class as global constants, because we need the categories also in other classes.

let collisionBulletCategory: UInt32  = 0x1 << 0
let collisionHeroCategory: UInt32    = 0x1 << 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var tankSprites: [SKSpriteNode] = []
    var tankTextures: [SKTexture] = []
    var vectors: [CGVector] = []
    var bullets: [SKSpriteNode] = []
    
    func didBeginContact(contact: SKPhysicsContact) {
        NSLog("Player loser")
        tankSprites[0].removeAllActions()
        self.tankSprites[0].runAction(SKAction.fadeOutWithDuration(0.5), completion: {
            self.tankSprites[0].position = CGPointMake(self.size.width/2, self.size.height/2)
            self.tankSprites[0].runAction(SKAction.fadeInWithDuration(0.5), completion: {
                NSLog("Player killed!")
                self.bullets[0].removeAllActions()
                self.bullets[0].runAction(SKAction.hide(), completion: {
                    NSLog("No bullet")
                    self.removeFromParent()
                    
                    //NSLog(String(self.bullets))
                })
                self.bullets = []
            })
        })
    }
    
    func setTankSprites() {
        let sprite = SKSpriteNode(imageNamed: "tank_U.png")
        let sprite1 = SKSpriteNode(imageNamed: "tank_U.png")
        tankSprites.append(sprite)
        tankSprites.append(sprite1)
    }
    
    func setTextures() {
        for item in 0...tankSprites.count-1 {
            tankSprites[item].texture = SKTexture(imageNamed: "tank_U.png")
            tankTextures.append(tankSprites[item].texture!)
            tankSprites[item].texture = SKTexture(imageNamed: "tank_D.png")
            tankTextures.append(tankSprites[item].texture!)
            tankSprites[item].texture = SKTexture(imageNamed: "tank_L.png")
            tankTextures.append(tankSprites[item].texture!)
            tankSprites[item].texture = SKTexture(imageNamed: "tank_R.png")
            tankTextures.append(tankSprites[item].texture!)
        }
    }
    
    func setVectors() {
        let vectorRight = CGVectorMake(10.0, 0.0)
        let vectorLeft = CGVectorMake(-10.0, 0.0)
        let vectorUp = CGVectorMake(0.0, 10.0)
        let vectorDown = CGVectorMake(0.0, -10.0)
        
        vectors.append(vectorUp)
        vectors.append(vectorDown)
        vectors.append(vectorLeft)
        vectors.append(vectorRight)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        setTankSprites()
        setTextures()
        setVectors()
        tankSprites[0].anchorPoint = CGPoint(x:0.5,y:0.5)
        tankSprites[0].position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(tankSprites[0])
        tankSprites[1].anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tankSprites[1].position = CGPoint(x:CGRectGetMidX(self.frame)/2, y:CGRectGetMidY(self.frame)/2)
        self.addChild(tankSprites[1])
        // Handle collisions
        self.physicsWorld.contactDelegate = self
        
        // Add physics body for collision detection
        tankSprites[0].physicsBody?.dynamic = true
        tankSprites[0].physicsBody = SKPhysicsBody(texture: tankSprites[0].texture!, size: tankSprites[0].size)
        tankSprites[0].physicsBody?.affectedByGravity = false
        tankSprites[0].physicsBody?.categoryBitMask = collisionHeroCategory
        tankSprites[0].physicsBody?.contactTestBitMask = collisionBulletCategory
        tankSprites[0].physicsBody?.collisionBitMask = 0x0
    }
    
    //test function
    
    func returnChar(theEvent: NSEvent!) -> Character?{
        let s: String = theEvent.characters!
        for char in s.characters {return char}
        return nil
    }
    
    override func keyDown(theEvent: NSEvent) {
        let s: String = String(self.returnChar(theEvent)!)
        switch(s){
        case "w":
            self.tankSprites[0].texture = tankTextures[0]
            self.tankSprites[0].runAction(SKAction.moveByX(0.0, y: 15.0, duration:0.2))
            return
        case "s":
            self.tankSprites[0].texture = tankTextures[1]
            self.tankSprites[0].runAction(SKAction.moveByX(0.0, y: -15.0, duration:0.2))
            return
        case "a":
            self.tankSprites[0].texture = tankTextures[2]
            self.tankSprites[0].runAction(SKAction.moveByX(-15.0, y: 0.0, duration:0.2))
            return
        case "d":
            self.tankSprites[0].texture = tankTextures[3]
            self.tankSprites[0].runAction(SKAction.moveByX(15.0, y: 0.0, duration:0.2))
            return
        case "i":
            self.tankSprites[1].texture = tankTextures[0]
            self.tankSprites[1].runAction(SKAction.moveByX(0.0, y: 15.0, duration:0.2))
            return
        case "k":
            self.tankSprites[1].texture = tankTextures[1]
            self.tankSprites[1].runAction(SKAction.moveByX(0.0, y: -15.0, duration:0.2))
            break
        case "j":
            self.tankSprites[1].texture = tankTextures[2]
            self.tankSprites[1].runAction(SKAction.moveByX(-15.0, y: 0.0, duration:0.2))
            break
        case "l":
            self.tankSprites[1].texture = tankTextures[3]
            self.tankSprites[1].runAction(SKAction.moveByX(15.0, y: 0.0, duration:0.2))
        case "q":
            self.shoot1()
            return
        case "u":
            self.shoot2()
            return
    
        default:
            break
        }
        super.keyDown(theEvent)
    }
    
    
    func shoot1() {
        
        let bullet = SKSpriteNode()
        bullet.color = NSColor.greenColor()
        bullet.size = CGSize(width: 5,height: 5)
        bullet.position = CGPointMake(tankSprites[0].position.x, tankSprites[0].position.y)
        self.addChild(bullet)
        
        var bulletAction: SKAction?
        
        //Create the actions
        for item in 0...tankTextures.count-1 {
            if self.tankSprites[0].texture == tankTextures[item] {
                bulletAction = SKAction.sequence([SKAction.repeatAction(SKAction.moveBy(vectors[item], duration: 0.05), count: Int(CGRectGetWidth(self.frame))/10), SKAction.waitForDuration(30.0/60.0),
                    SKAction.removeFromParent()])
                bullet.runAction(bulletAction!)
            }
            
        }
        // Add physics body for collision detection
//        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
//        bullet.physicsBody?.dynamic = true
//        bullet.physicsBody?.affectedByGravity = false
//        bullet.physicsBody?.categoryBitMask = collisionBulletCategory
//        bullet.physicsBody?.contactTestBitMask = collisionHeroCategory
//        
//        bullet.physicsBody?.collisionBitMask = 0x0;
    }
    
    func shoot2() {
        
        let bullet = SKSpriteNode()
        bullet.color = NSColor.redColor()
        bullet.size = CGSize(width: 5,height: 5)
        bullet.position = CGPointMake(tankSprites[1].position.x, tankSprites[1].position.y)
        self.addChild(bullet)
        bullets.append(bullet)
        
        var bulletAction: SKAction?
        
        //Create the actions
        for item in 0...tankTextures.count-1 {
            if self.tankSprites[1].texture == tankTextures[item] {
                bulletAction = SKAction.sequence([SKAction.repeatAction(SKAction.moveBy(vectors[item], duration: 0.05), count: Int(CGRectGetWidth(self.frame))/10), SKAction.waitForDuration(30.0/60.0),
                    SKAction.removeFromParent()])
                bullet.runAction(bulletAction!)
            }
            
        }
        // Add physics body for collision detection
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = collisionBulletCategory
        bullet.physicsBody?.contactTestBitMask = collisionHeroCategory
        
        bullet.physicsBody?.collisionBitMask = 0x0;
    }
    
}
