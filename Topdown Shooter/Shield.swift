//
//  Shield.swift
//  Topdown Shooter
//
//  Created by cadet on 05/08/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit


class Shield : SKNode
{
    let fullHealth: CGFloat = 100.0
    var health:     CGFloat = 100.0
    var shield :    SKSpriteNode?
 
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init()
    {
        //self.fullHealth = 100
        self.health = 100
        
        super.init()
        
        addChild(shield!)
    }
    
    init(size: CGSize)
    {
        
        self.health = 100
        
        //Create Sprite
        let texture = SKTexture(imageNamed: "spr_shield")
        shield = SKSpriteNode(texture: texture, color: .white, size: size)
        shield?.position = CGPoint(x: 0.5, y: 0.5)
        //shield?.isHidden = false
        super.init()
        //super.init(texture: texture, color: UIColor.white, size: size)
        
        self.name = "shield"
        self.zPosition = GameZLayer.Player + 1
        
        configureCollisonBody()
        
        addChild(shield!)
    }
    
    @discardableResult func takeDamage(_ damage: CGFloat) -> Bool
    {
        health = max(health - damage, 0)

        let scaleDownAction = SKAction.scale(to: 0.5, duration: 1.0)
        let scaleUpAction = SKAction.scale(to: 1, duration: 1.0)
        let colorizeDownAction = SKAction.colorize(with: .blue, colorBlendFactor: -1.0, duration: 1.0)
        let colorizeUpAction = SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 1.0)
        let powerDownGroup = SKAction.group([scaleDownAction, colorizeDownAction])
        let powerUpGroup = SKAction.group([scaleUpAction, colorizeUpAction])
        shield?.run(SKAction.sequence([powerDownGroup, powerUpGroup]))
        
        if health == 0
        {
            shield?.run(powerDownGroup)
            removeFromParent()
        }
        
        return health == 0
        
    }
    
    func configureCollisonBody()
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius: (shield?.size.width)! / 2)
        //self.physicsBody?.allowsRotation = true
        //self.physicsBody?.friction = 0
        //self.physicsBody?.linearDamping = 0
        //self.physicsBody?.angularDamping = 0
        //self.physicsBody?.restitution = 0.7
        //self.physicsBody?.mass = 0.4
        
        //Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
        self.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Shield
        
        //Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
        self.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Asteroid | PhysicsCollisionBitMask.Alien | PhysicsCollisionBitMask.Ufo
        //self.physicsBody?.collisionBitMask = 0
        
        //Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
        self.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Asteroid | PhysicsCollisionBitMask.Alien
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false

    }

    func isActive() -> Bool
    {
        if health > 0
        {
            return true
        }
        
        return false
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
            takeDamage(50)
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

        if (health) < 30.0
        {
//            ventingPlasma?.isHidden = false
        }
        
//        ventingPlasma!.isHidden = (healthBar?.currentHealth())! > CGFloat(30.0)
        
        if (isActive())
        {
            
            //Spaceship destroyed
            health = 0.0
          //  self.isHidden = true
            
            //Blow up spaceship
            //let mainScene = scene as! GameScene
            //mainScene.createExplosion(nodeToExplode: self)
            
            //Restore health
            //health = 100.0
        }
    }
    
    
    func update(_ delta: TimeInterval) {}
    
}
