//
//  Shield.swift
//  Topdown Shooter
//
//  Created by cadet on 05/08/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit


class Shield : SKSpriteNode
{
    let fullHealth: CGFloat = 100.0
    var health: CGFloat = 100.0
    // shield : SKSpriteNode
 
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize)
    {
        
        //Create Sprite
        let texture = SKTexture(imageNamed: "spr_shield")
        super.init(texture: texture, color: UIColor.white, size: size)
        
        self.name = "shield"
        self.zPosition = GameZLayer.Player + 1
        
        configureCollisonBody()
    }
    
    @discardableResult func takeDamage(_ damage: CGFloat) -> Bool
    {
        health = max(health - damage, 0)
        
        //healthBar?.isHidden = false
        let healthScale = health/fullHealth
        let scaleAction = SKAction.scaleX(to: healthScale, duration: 0.5)
        let fadeAction = SKAction.fadeOut(withDuration: 1.0)
        //healthBar?.run(SKAction.group([soundAction, scaleAction, fadeAction]))
        
        /*        if health == 0
         {
         if entity != nil
         {
         
         }
         }
         */
        return health == 0
        
    }
    
    func configureCollisonBody()
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.allowsRotation = true
        //self.physicsBody?.friction = 0
        //self.physicsBody?.linearDamping = 0
        //self.physicsBody?.angularDamping = 0
        //self.physicsBody?.restitution = 0.7
        //self.physicsBody?.mass = 0.4
        
        //Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
        self.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Shield
        
        //Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
        //self.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Asteroid | PhysicsCollisionBitMask.Alien | PhysicsCollisionBitMask.Ufo
        self.physicsBody?.collisionBitMask = 0
        
        //Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
        self.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Asteroid | PhysicsCollisionBitMask.Alien
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
    }

    
    func collidedWith(_ body: SKPhysicsBody, contact: SKPhysicsContact)
    {
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        
        //print("body\(body)")
        //print("contact A\(contact.bodyA.node?.name)")
        //print("contact B\(contact.bodyB.node?.name)")
        
        if bodyA == "asteroid" ||
            bodyB == "asteroid"
        {
            //healthBar?.takeDamage(50)
        }
        else if bodyA == "alien" ||
            bodyB == "alien"
        {
         //   healthBar?.takeDamage(5)
        }
        else if bodyA == "ground" ||
            bodyB == "ground"
        {
           // healthBar?.takeDamage(1)
        }
/*
        if (healthBar?.health)! < 30.0
        {
            ventingPlasma?.isHidden = false
        }
        
        ventingPlasma!.isHidden = (healthBar?.currentHealth())! > CGFloat(30.0)
        
        if !(healthBar?.isAlive())!
        {
            
            //Spaceship destroyed
            healthBar?.health = 0.0
            
            //Blow up spaceship
            let mainScene = scene as! GameScene
            mainScene.createExplosion(nodeToExplode: self)
            
            //Restore health
            healthBar?.health = 100.0
        }
 */
    }
    
    
    func update(_ delta: TimeInterval) {}
    
}
