//
//  Spaceship.swift
//  Side Shooter
//
//  Created by cadet on 15/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit


class Spaceship: GameEntity
{
    let ventingPlasma = SKEmitterNode(fileNamed: "ventingPlasma.sks")
    var healthBar : HealthBar?
    
    let spaceshipAtlas = SKTextureAtlas(named:"Spaceship")
    var spaceshipSprites = Array<SKTexture>()
    
    required init?(coder aDecoder: NSCoder)
    {
        healthBar = HealthBar()
        super.init(coder:aDecoder)
    }
    
    init(entityPosition: CGPoint, entityTexture: SKTexture)
    {
        let texture = SKTexture(imageNamed: "Spaceship")
//        super.init(position: entityPosition, texture: entityTexture)
        super.init(position:entityPosition, texture: texture)
        name = "spaceship"
        self.size = CGSize(width: 50, height: 50)
        self.position = entityPosition
        self.zPosition = 1
        //ventingPlasma!.isHidden = true
        //addChild(ventingPlasma!)
        configureCollisionBody()

        healthBar = HealthBar(size: self.size, barOffset: 25)
        addChild(healthBar!)

    }
    
    func createSpriteAtlas()
    {
        spaceshipSprites.append(spaceshipAtlas.textureNamed("spaceflier_01_a"))
        spaceshipSprites.append(spaceshipAtlas.textureNamed("spaceflier_02_a"))
        spaceshipSprites.append(spaceshipAtlas.textureNamed("spaceflier_03_a"))
    }
    
    
    func configureCollisionBody()
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.1
        self.physicsBody?.restitution = 0.3
        self.physicsBody?.mass = 0.4
        
        //Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
        self.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Player
        
        //Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
        //self.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Asteroid | PhysicsCollisionBitMask.Ground | PhysicsCollisionBitMask.Alien

        //Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
        self.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Asteroid | PhysicsCollisionBitMask.Alien
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
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
            healthBar?.takeDamage(50)
        }
        else if bodyA == "alien" ||
                bodyB == "alien"
        {
            healthBar?.takeDamage(5)
        }
        else if bodyA == "ground" ||
                bodyB == "ground"
        {
            healthBar?.takeDamage(1)
        }
        
        if (healthBar?.health)! < 30.0
        {
            ventingPlasma?.isHidden = false
        }
        
 //       ventingPlasma!.isHidden = healthBar?.currentHealth() > 30.0
        
        if !(healthBar?.isAlive())!
        {
            
            //Blow up spaceship
            healthBar?.health = 0.0
            let mainScene = scene as! GameScene
            //mainScene.createExplosion(nodeToExplode: self)
            
            healthBar?.health = 100.0
        }
    }
}
