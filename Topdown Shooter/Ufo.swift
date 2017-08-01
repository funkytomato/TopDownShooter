//
//  Ufo.swift
//  Topdown Shooter
//
//  Created by cadet on 22/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit


class Ufo: GameEntity
{
    let ventingPlasma = SKEmitterNode(fileNamed: "ventingPlasma.sks")
    var healthBar : HealthBar?
    
    required init?(coder aDecoder: NSCoder)
    {
        healthBar = HealthBar()
        super.init(coder:aDecoder)
    }
    
    init(entityPosition: CGPoint, entityTexture: SKTexture)
    {
        
        super.init(position: entityPosition, texture: entityTexture)
        name = "ufo"
        self.size = CGSize(width: 35, height: 25)
        self.position = entityPosition
        self.zPosition = GameZLayer.Player
        ventingPlasma!.isHidden = true
        addChild(ventingPlasma!)
        configureCollisionBody()
        
        healthBar = HealthBar(size: self.size, barOffset: 25)
        addChild(healthBar!)
    }
    
    
    func configureCollisionBody()
    {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.1
        self.physicsBody?.restitution = 0.3
        self.physicsBody?.mass = 0.4
        
        //Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
        self.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Ufo
        
        //Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
        //self.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Player | PhysicsCollisionBitMask.Ground | PhysicsCollisionBitMask.Asteroid
        
        //Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
        self.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Asteroid | PhysicsCollisionBitMask.Laser | PhysicsCollisionBitMask.Player
        
        
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.affectedByGravity = false
    }
    
    
    override func collidedWith(_ body: SKPhysicsBody, contact: SKPhysicsContact)
    {
        
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        
        print("body\(body)")
        print("contact A\(contact.bodyA.node?.name)")
        print("contact B\(contact.bodyB.node?.name)")
        
        if bodyA == "asteroid" ||
            bodyB == "asteroid"
        {
            healthBar!.takeDamage(50)
        }
        else if bodyA == "alien" ||
            bodyB == "alien"
        {
            healthBar!.takeDamage(5)
        }
        else if bodyA == "ufo" ||
            bodyB == "ufo"
        {
            healthBar!.takeDamage(1)
        }
        else if bodyA == "spaceship" ||
            bodyB == "spaceship"
        {
            
        }
        
        ventingPlasma!.isHidden = (healthBar?.health)! > CGFloat(30.0)
        
        if (healthBar?.health)! < 30.0
        {
            ventingPlasma?.isHidden = false
        }
        
        
        if !(healthBar?.isAlive())!
        {
            
            //Blow up spaceship
            healthBar?.health = 0.0
            let mainScene = scene as! GameScene
            mainScene.createExplosion(nodeToExplode: self)
            
            healthBar?.health = 100.0
        }
    }
}
