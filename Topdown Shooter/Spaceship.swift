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
    /*
    let MaxPlayerAccel : CGFloat = 400.0;
    let MaxPlayerSpeed : CGFloat = 200.0;
    var _playerAccelX : CGFloat = 0;
    var _playerAccelY : CGFloat = 0;
    var _playerSpeedX : CGFloat = 0;
    var _playerSpeedY : CGFloat = 0;
    */
    
    //let rotateAngle : CGFloat = π / 4   //45 degrees
    let rotateAngle : CGFloat = π / 28
    
    var isTurningLeft = false
    var isTurningRight = false
    var isThrusting = false
    var isReversing = false
 
    let ventingPlasma = SKEmitterNode(fileNamed: "ventingPlasma.sks")
    var healthBar : HealthBar?
    
    
    var moveAndRemoveLaser = SKAction()
    
    required init?(coder aDecoder: NSCoder)
    {
        healthBar = HealthBar()
        super.init(coder:aDecoder)
    }
    
    override init()
    {
        super.init()
        
        configureSpaceship()
    }
    
    init(entityPosition: CGPoint, entityTexture: SKTexture)
    {
        
        //Create Sprite
        let texture = SKTexture(imageNamed: "Spaceship")
        super.init(position:entityPosition, texture: texture)
        
        //Define Sprite Node
        self.name = "spaceship"
        self.size = CGSize(width: 50, height: 50)
        self.position = entityPosition
        self.zPosition = 1
        
        configureSpaceship()
        
    }

    func configureSpaceship()
    {
        configureVentPlasma()
        configureCollisionBody()
        configureHealthBar()
    }
    
    func configureVentPlasma()
    {
        //Configure venting plasma particle effect
        ventingPlasma!.isHidden = false
        addChild(ventingPlasma!)
    }
    
    
    func configureHealthBar()
    {
        //Configure the health bar
        healthBar = HealthBar(size: self.size, barOffset: 25)
        addChild(healthBar!)
    }
    
    func configureCollisionBody()
    {
        print("configureCollisionBody")
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0.3
        self.physicsBody?.linearDamping = 1.1
        self.physicsBody?.restitution = 0.7
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
        
   //     ventingPlasma!.isHidden = healthBar?.currentHealth() > 30.0
        
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
    }
    
    func applyThrust()
    {
        
        
        let dx = (30 * cos(heading()))
        let dy = (30 * sin(heading()))
        
        let impulse = CGVector(dx: dx, dy: dy)
        
        self.physicsBody?.applyImpulse(impulse)

        //Limit spaceship's speed
        if (self.physicsBody?.velocity.dx)! > CGFloat(800.0)
        {
            self.physicsBody?.velocity = CGVector(dx: 200, dy: self.physicsBody!.velocity.dy);
        }
        
        if (self.physicsBody?.velocity.dy)! > CGFloat(800.0)
        {
            self.physicsBody?.velocity = CGVector(dx: (self.physicsBody?.velocity.dx)!, dy: 200)
        }
    }
    
    func reverseThrust()
    {

        let dx = (10 * cos(aft()))
        let dy = (10 * sin(aft()))
        
        let impulse = CGVector(dx: dx, dy: dy)
        self.physicsBody?.applyImpulse(impulse)
    }
    
    func heading() -> CGFloat
    {
        //Need to align the sprite orientation and the physics body
        return self.zRotation + CGFloat(90).degreesToRadians()
    }
    
    func aft() -> CGFloat
    {
       // print("zrottation:\(self.zRotation)")
        
        let aft = (self.zRotation / 2)
       // print("aft:\(aft + CGFloat(90).degreesToRadians())")
        
        //Need to align the sprite orientation and the physics body
        return aft - CGFloat(90).degreesToRadians()
        
    }
    
    func rotateLeft()
    {
        //let angle : CGFloat = π / 4   //45 degrees

        let rotate : SKAction = SKAction.rotate(byAngle: rotateAngle, duration: 0)
        self.run(rotate)

        
    //    print("zRotation:\(self.zRotation)")
        
    }
    
    func rotateRight()
    {
        
        let rotate : SKAction = SKAction.rotate(byAngle: -rotateAngle, duration: 0)
        self.run(rotate)
        
        
        //print("zRotation:\(self.zRotation)")
    }
    
    func shootGuns() -> SKNode
    {
        //Define the target point
        let laserDistance = CGFloat(2000)
        let dx = (laserDistance * cos(heading()))
        let dy = (laserDistance * sin(heading()))
        
        //The Laser creation and deletion sequence
        let moveLaser = SKAction.moveBy(x: dx, y: dy, duration: TimeInterval(0.001 * laserDistance))
        let removeLaser = SKAction.removeFromParent()
        moveAndRemoveLaser = SKAction.sequence([moveLaser, removeLaser])
        
        //Create the laser
        let texture = SKTexture(imageNamed: "laserBlue01")
        let laser = SKSpriteNode(texture: texture)
        laser.name = "laser"
        laser.position.y = self.position.y
        laser.position.x = self.position.x
        laser.zRotation = self.zRotation
        laser.zPosition = 1
        
        //Create the physics body
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.allowsRotation = false
        laser.physicsBody?.usesPreciseCollisionDetection = true
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.mass = 1
        
        //Set the physics body
        laser.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Laser
        laser.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Asteroid
        laser.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Alien

        //Set the laser action running
        laser.run(moveAndRemoveLaser)

        return laser

        
    }
    
    
    override func update(_ delta: TimeInterval)
    {
 //       self.rotateToVelocity((self.physicsBody?.velocity)!, rate: 1)

        if isTurningLeft
        {
            rotateLeft()
        }
        else if isTurningRight
        {
            rotateRight()
        }
        
        if isThrusting
        {
            applyThrust()
        }
        else if isReversing
        {
            reverseThrust()
        }
    }
}
