//
//  Asteroid.swift
//  Side Shooter
//
//  Created by cadet on 18/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import Foundation

import SpriteKit


class Asteroid: GameEntity
{
    //let asteroidDust = SKEmitterNode(fileNamed: "asteroidDust")
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    init(entityPosition: CGPoint, entityTexture: SKTexture, size: CGSize)
    {
        let texture = SKTexture(imageNamed: "meteorBrown_med1")
        super.init(position:entityPosition, texture: texture)
        name = "asteroid"
        self.size = size
        self.position = entityPosition
        self.color = SKColor.blue
        self.zPosition = 1
        
   //     asteroidDust!.isHidden = false
    //    addChild(asteroidDust!)
        
        configureCollisionBody()
        
    }
    
    
    func configureCollisionBody()
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.0)
        self.zRotation = 2.0
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 1
        self.physicsBody?.restitution = (self.size.width + self.size.height / 2) / 100
        print("Asteroid Restitution:\((self.size.width + self.size.height / 2) / 100)")
        
        //Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
        self.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Asteroid
        
        //Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
        //self.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Ground
        
        //Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
        self.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Player | PhysicsCollisionBitMask.Alien | PhysicsCollisionBitMask.Laser

    }
    
    
    override func collidedWith(_ body: SKPhysicsBody, contact: SKPhysicsContact)
    {
        
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        
        print("body\(body)")
        print("contact A\(contact.bodyA.node?.name)")
        print("contact B\(contact.bodyB.node?.name)")
        
        if bodyA == "spaceship" ||
            bodyB == "spaceship"
        {

        }
        else if bodyA == "alien" ||
            bodyB == "alien"
        {
            //health -= 5.0
        }
        else if bodyA == "laser" ||
            bodyB == "laser"
        {
            //health -= 1.0
            let mainScene = scene as! GameScene
            mainScene.createExplosion(nodeToExplode: self)
        }
        
        //asteroidDust!.isHidden = health > 30.0
    }
}
