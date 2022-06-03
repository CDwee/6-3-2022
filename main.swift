// Started at 10:29 6-3-2022

import UIKit
import SpriteKit
import GameplayKit

class ActionScene: SKScene {
    
    var sprite1 : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        sprite1 = self.childNode(withName: "spriteNode1") as? SKSpriteNode
        
        // 0sec: moveby 100,100 and scale 3x
        // 1sec: moveto 100,100, start rotation
        // 2sec: moveby 100,100, keep rotating until 3sec
        // 3sec: fade out
        
        let moveByAction = SKAction.moveBy(x: 100, y: 100, duration: 1)
        let moveToAction = SKAction.move(to: CGPoint(x: 100, y: 100), duration: 1)
        let scaleByAction = SKAction.scale(by: 3, duration: 1)
        let rotationByAction = SKAction.rotate(byAngle: CGFloat(2*M_PI), duration: 2)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1)
        
        //let sequence1 = SKAction.sequence([moveByAction,moveToAction,moveByAction, fadeOutAction])
        
        let sequence1 = SKAction.sequence([moveByAction,moveToAction,moveByAction])
        let sequence2 = SKAction.sequence([scaleByAction,rotationByAction])
        let combinedAction = SKAction.group([sequence1,sequence2])
        let waitAction = SKAction.wait(forDuration: 1)
        
        let combinedWithWait = SKAction.sequence([combinedAction,waitAction])
        
        let repeatedAction = SKAction.repeat(combinedWithWait, count: 3)
        
        //sprite1?.run(combinedAction)
        sprite1?.run(repeatedAction)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


import UIKit
import SpriteKit
import GameplayKit

class PhysicsScene: SKScene {
    
    var sprite1 : SKSpriteNode?
    var sprite2 : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        sprite1 = self.childNode(withName: "spriteNode1") as? SKSpriteNode
        sprite2 = self.childNode(withName: "spriteNode2") as? SKSpriteNode
        
        let physicsBody1 = sprite1?.physicsBody
        let physicsBody2 = sprite2?.physicsBody
        
        let edgePhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        edgePhysicsBody.restitution = 1
        edgePhysicsBody.friction = 0
        edgePhysicsBody.categoryBitMask = 0b1
        edgePhysicsBody.collisionBitMask = 0b10 | 0b100
        edgePhysicsBody.contactTestBitMask = 0b10 | 0b100
        self.physicsBody = edgePhysicsBody
        
        physicsBody1?.categoryBitMask = 0b10
        physicsBody1?.contactTestBitMask = 0b1 | 0b100
        physicsBody1?.collisionBitMask = 0b1 | 0b100
        sprite1?.physicsBody = physicsBody1
        
        physicsBody2?.categoryBitMask = 0b100
        physicsBody2?.collisionBitMask = 0b10 | 0b1
        physicsBody2?.contactTestBitMask = 0b10 | 0b1
        sprite2?.physicsBody = physicsBody2
        
        physicsBody1?.applyImpulse(CGVector(dx: 100, dy: 100))
        physicsBody2?.applyImpulse(CGVector(dx: -100, dy: 100))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


import UIKit
import SpriteKit
import GameplayKit

class PhysicsScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite1 : SKSpriteNode?
    var sprite2 : SKSpriteNode?
    let startImpulse : CGFloat = 20
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        sprite1 = self.childNode(withName: "spriteNode1") as? SKSpriteNode
        sprite2 = self.childNode(withName: "spriteNode2") as? SKSpriteNode
        
        let physicsBody1 = sprite1?.physicsBody
        let physicsBody2 = sprite2?.physicsBody
        
        let edgePhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        edgePhysicsBody.restitution = 1
        edgePhysicsBody.friction = 0
        edgePhysicsBody.categoryBitMask = 0b1
        edgePhysicsBody.collisionBitMask = 0b10 | 0b100
        edgePhysicsBody.contactTestBitMask = 0b10 | 0b100
        self.physicsBody = edgePhysicsBody
        
        physicsBody1?.categoryBitMask = 0b10
        physicsBody1?.contactTestBitMask = 0b1 | 0b100
        physicsBody1?.collisionBitMask = 0b1 | 0b100
        sprite1?.physicsBody = physicsBody1
        
        physicsBody2?.categoryBitMask = 0b100
        physicsBody2?.collisionBitMask = 0b10 | 0b1
        physicsBody2?.contactTestBitMask = 0b10 | 0b1
        sprite2?.physicsBody = physicsBody2
        
        physicsBody1?.applyImpulse(CGVector(dx: startImpulse, dy: startImpulse))
        physicsBody2?.applyImpulse(CGVector(dx: -startImpulse, dy: startImpulse))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var wallNode : SKNode?
        var otherNode : SKNode?
        
        if contact.bodyA.categoryBitMask == 0b1 {
            wallNode = contact.bodyA.node
            otherNode = contact.bodyB.node
        } else if contact.bodyB.categoryBitMask == 0b1 {
            wallNode = contact.bodyB.node
            otherNode = contact.bodyA.node
        } else {
            return
        }
        
        let xPos = contact.contactPoint.x
        let yPos = contact.contactPoint.y
        
        let dx = otherNode?.physicsBody?.velocity.dx
        let dy = otherNode?.physicsBody?.velocity.dy
        
        if xPos >= self.frame.maxX - 5 && dx! >= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: -startImpulse, dy: 0))
        } else if xPos <= self.frame.minX + 5 && dx! <= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: startImpulse, dy: 0))
        }
        
        if yPos >= self.frame.maxY - 5 && dy! >= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -startImpulse))

        } else if yPos <= self.frame.minY + 5 && dy! <= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: startImpulse))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


import UIKit
import SpriteKit
import GameplayKit

class PhysicsScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite1 : SKSpriteNode?
    var sprite2 : SKSpriteNode?
    let startImpulse : CGFloat = 120
    var fieldNode : SKFieldNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        sprite1 = self.childNode(withName: "spriteNode1") as? SKSpriteNode
        sprite2 = self.childNode(withName: "spriteNode2") as? SKSpriteNode
        
        let physicsBody1 = sprite1?.physicsBody
        let physicsBody2 = sprite2?.physicsBody
        
        let edgePhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        edgePhysicsBody.restitution = 1
        edgePhysicsBody.friction = 0
        edgePhysicsBody.categoryBitMask = 0b1
        edgePhysicsBody.collisionBitMask = 0b10 | 0b100
        edgePhysicsBody.contactTestBitMask = 0b10 | 0b100
        self.physicsBody = edgePhysicsBody
        
        physicsBody1?.categoryBitMask = 0b10
        physicsBody1?.contactTestBitMask = 0b1 | 0b100
        physicsBody1?.collisionBitMask = 0b1 | 0b100
        physicsBody1?.fieldBitMask = 0b1
        sprite1?.physicsBody = physicsBody1
        
        physicsBody2?.categoryBitMask = 0b100
        physicsBody2?.collisionBitMask = 0b10 | 0b1
        physicsBody2?.contactTestBitMask = 0b10 | 0b1
        physicsBody2?.fieldBitMask = 0b10
        sprite2?.physicsBody = physicsBody2
        
        physicsBody1?.applyImpulse(CGVector(dx: startImpulse, dy: startImpulse))
        physicsBody2?.applyImpulse(CGVector(dx: -startImpulse, dy: startImpulse))
        
        fieldNode = SKFieldNode.springField()
        fieldNode?.categoryBitMask = 0b1
        fieldNode?.strength = 3
        fieldNode?.falloff = 0
        fieldNode?.isEnabled = true
        fieldNode?.position = CGPoint(x: 0, y: 0)
        fieldNode?.region = SKRegion(radius: 200)
        self.addChild(fieldNode!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var wallNode : SKNode?
        var otherNode : SKNode?
        
        if contact.bodyA.categoryBitMask == 0b1 {
            wallNode = contact.bodyA.node
            otherNode = contact.bodyB.node
        } else if contact.bodyB.categoryBitMask == 0b1 {
            wallNode = contact.bodyB.node
            otherNode = contact.bodyA.node
        } else {
            return
        }
        
        let xPos = contact.contactPoint.x
        let yPos = contact.contactPoint.y
        
        let dx = otherNode?.physicsBody?.velocity.dx
        let dy = otherNode?.physicsBody?.velocity.dy
        
        if xPos >= self.frame.maxX - 5 && dx! >= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: -startImpulse, dy: 0))
        } else if xPos <= self.frame.minX + 5 && dx! <= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: startImpulse, dy: 0))
        }
        
        if yPos >= self.frame.maxY - 5 && dy! >= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -startImpulse))

        } else if yPos <= self.frame.minY + 5 && dy! <= CGFloat(0) {
            otherNode?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: startImpulse))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerPaddle : SKSpriteNode?
    var ball : SKSpriteNode?
    var label : SKLabelNode?
    
    var startImpulse : CGFloat = 50
    var isGameOver = false
    var brickCount = 9
    
    enum bitMasks : UInt32 {
        case edgeBitMask = 0b1
        case playerPaddleBitMask = 0b10
        case ballBitMask = 0b100
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        playerPaddle = self.childNode(withName: "playerPaddle") as? SKSpriteNode
        ball = self.childNode(withName: "ball") as? SKSpriteNode
        
        let edgePhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        edgePhysicsBody.categoryBitMask = bitMasks.edgeBitMask.rawValue
        edgePhysicsBody.contactTestBitMask = bitMasks.ballBitMask.rawValue
        edgePhysicsBody.collisionBitMask = bitMasks.ballBitMask.rawValue
        edgePhysicsBody.friction = 0
        edgePhysicsBody.restitution = 1
        edgePhysicsBody.isDynamic = false
        self.physicsBody = edgePhysicsBody
        self.name = "scene"
        
        ball?.physicsBody?.contactTestBitMask = bitMasks.edgeBitMask.rawValue | bitMasks.playerPaddleBitMask.rawValue
        ball?.physicsBody?.collisionBitMask = bitMasks.edgeBitMask.rawValue | bitMasks.playerPaddleBitMask.rawValue
        ball?.physicsBody?.applyImpulse(CGVector(dx: startImpulse, dy: startImpulse))
        
        label = SKLabelNode(fontNamed: "Game Over")
        label?.fontColor = UIColor.white
        label?.fontSize = 80
        label?.position = CGPoint(x: 0, y: 0)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.size = self.frame.size
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene)
            }
        }
        
        for t in touches {
            let xLocation = t.location(in: self).x
            playerPaddle?.position = CGPoint(x: xLocation, y: (playerPaddle?.position.y)!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let xLocation = t.location(in: self).x
            playerPaddle?.position = CGPoint(x: xLocation, y: (playerPaddle?.position.y)!)
        }
     }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var ballNode : SKNode!
        var otherNode : SKNode!
        
        let xPos = contact.contactPoint.x
        let yPos = contact.contactPoint.y
        
        if contact.bodyA.node?.name == "ball" {
            ballNode = contact.bodyA.node
            otherNode = contact.bodyB.node
        } else if contact.bodyB.node?.name == "ball" {
            ballNode = contact.bodyB.node
            otherNode = contact.bodyA.node
        }
        
        if otherNode.name == "brick" {
            otherNode.removeFromParent()
            brickCount -= 1
            if brickCount == 0 {
                isGameOver = true
                label?.text = "You win!"
                self.addChild(label!)
            }
        } else if otherNode.name == "scene" {
            if yPos <= self.frame.minY + 5 {
                isGameOver = true
                label?.text = "You lose! Touch the screen to play again"
                self.addChild(label!)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver {
            self.isPaused = true
        }
    }
}

// Ended at 5:00 6-3-2022
