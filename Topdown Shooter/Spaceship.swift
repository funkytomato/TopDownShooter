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
    var _playerAccelX : Float64 = 0
    var _playerAccelY : Float64 = 0
    var _playerSpeedX : Float64 = 0
    var _playerSpeedY : Float64 = 0
    let MaxPlayerAccel : Float64 = 400.0
    let MaxPlayerSpeed : Float64 = 200.0
 */
    
    let rotateAngle : CGFloat = π / 4   //45 degrees

    var thrusting = false
    var reversing = false
 
    let ventingPlasma = SKEmitterNode(fileNamed: "ventingPlasma.sks")
    var healthBar : HealthBar?
    
    //let spaceshipAtlas = SKTextureAtlas(named:"Spaceship")
    //var spaceshipSprites = Array<SKTexture>()
    
    
    var moveAndRemoveLaser = SKAction()
    
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
        self.name = "spaceship"
        self.size = CGSize(width: 50, height: 50)
        self.position = entityPosition
        self.zPosition = 1
        //ventingPlasma!.isHidden = true
        //addChild(ventingPlasma!)
        configureCollisionBody()

        healthBar = HealthBar(size: self.size, barOffset: 25)
        addChild(healthBar!)
        

    }
    /*
    func createSpriteAtlas()
    {
        spaceshipSprites.append(spaceshipAtlas.textureNamed("spaceflier_01_a"))
        spaceshipSprites.append(spaceshipAtlas.textureNamed("spaceflier_02_a"))
        spaceshipSprites.append(spaceshipAtlas.textureNamed("spaceflier_03_a"))
    }
    */
    
    func configureCollisionBody()
    {
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
        
 //       ventingPlasma!.isHidden = healthBar?.currentHealth() > 30.0
        
        if !(healthBar?.isAlive())!
        {
            
            //Blow up spaceship
            healthBar?.health = 0.0
            //let mainScene = scene as! GameScene
            //mainScene.createExplosion(nodeToExplode: self)
            
            healthBar?.health = 100.0
        }
    }
    
    func applyThrust()
    {
   
        let dx = (10 * cos(heading()))
        let dy = (10 * sin(heading()))
        
        let impulse = CGVector(dx: dx, dy: dy)
        self.physicsBody?.applyImpulse(impulse)

        //self.rotateToVelocity((self.physicsBody?.velocity)!, rate: 1)

        
        /*
        //  Applying rocket thrust
        //
         
        let thrust : CGFloat = 0.12
        var thrustVector : CGVector
        
        thrustVector = CGPoint(Float(thrust)*cosf(Float(heading())),
                               Float(thrust)*sinf(Float(heading())));
        self.physicsBody?.applyForce(thrustVector)
        */
        
        
        //Applying lateral thrust
        //
/*
        let thrust : CGFloat = 0.01
        var thrustVector : CGVector
        
        thrustVector = CGPoint(Float(thrust)*cosf(Float(heading())),
                               Float(thrust)*sinf(Float(heading())));
        
        self.physicsBody?.applyTorque(thrustVector)
        
  */
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
        print("zrottation:\(self.zRotation)")
        
        let aft = (self.zRotation / 2)
        print("aft:\(aft + CGFloat(90).degreesToRadians())")
        
        //Need to align the sprite orientation and the physics body
        return aft - CGFloat(90).degreesToRadians()
        
    }
    
    func turnLeft()
    {
        //let angle : CGFloat = π / 4   //45 degrees
        
        self.removeAllActions()
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0.5)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        self.run(repeatRotation)
        
        //print("playerNode().zRotation\(playerNode().zRotation)")
        /*
         //let angle : CGFloat = π / 4   //45 degrees
         let angle : Float = Float(M_PI) / 4.0
         let point = CGPoint(x:4,y:4)
         
         let x = Float(point.x)
         let y = Float(point.y)
         
         var rotatedPoint : CGPoint = point
         rotatedPoint.x = CGFloat(x * cosf(Float(angle)) - y * sinf(angle))
         rotatedPoint.y = CGFloat(y * cosf(Float(angle)) + x * sinf(angle))
         //print("rotatedPoint\(rotatedPoint)")
         
         
         //playerNode().physicsBody?.velocity = CGVector(dx: 0, dy: 0)
         //playerNode().physicsBody?.applyImpulse(CGVector(dx: -100, dy: 0))
         */
    }
    
    func turnRight()
    {
        self.removeAllActions()
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat(-M_PI), duration: 1.0)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        self.run(repeatRotation)
    }
    
    func shootGuns() -> SKNode
    {
        let laserDistance = CGFloat(2000)
        
        let dx = (laserDistance * cos(heading()))
        let dy = (laserDistance * sin(heading()))
        
        //let impulse = CGVector(dx: dx, dy: dy)
        
        
        
        //The Laser creation and deletion sequence

        //let moveLaser = SKAction.moveBy(x: dx, y: dy, duration: TimeInterval(0.008 * laserDistance))
        let moveLaser = SKAction.moveBy(x: dx, y: dy, duration: TimeInterval(0.001 * laserDistance))

        let removeLaser = SKAction.removeFromParent()
        moveAndRemoveLaser = SKAction.sequence([moveLaser, removeLaser])
        
        
        
        let texture = SKTexture(imageNamed: "laserBlue01")
        let laser = SKSpriteNode(texture: texture)
        laser.zRotation = self.zRotation
        
        //laser.size = CGSize(width: 50, height: 20)
        //laser.position = CGPoint(x: self.position.x + 25, y: self.position.y + 420)
        
        laser.physicsBody?.allowsRotation = false
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Laser
        laser.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Asteroid
        laser.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Alien
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.mass = 1
        
        laser.zPosition = 1
        
        laser.position.y = self.position.y
        laser.position.x = self.position.x
        
        laser.run(moveAndRemoveLaser)

        return laser

        
    }
    
    override func update(_ delta: TimeInterval)
    {
 //       self.rotateToVelocity((self.physicsBody?.velocity)!, rate: 1)

/*
        // 1
        _playerSpeedX += _playerAccelX * delta;
        _playerSpeedY += _playerAccelY * delta;
        
                print("A. Player Speed:X\(_playerSpeedX),Y:\(_playerSpeedY)")
        
        // 2
        _playerSpeedX = Float64(fmaxf(fminf(Float(_playerSpeedX), Float(MaxPlayerSpeed)), -(Float)(MaxPlayerSpeed)));
        _playerSpeedY = Float64(fmaxf(fminf(Float(_playerSpeedY), Float(MaxPlayerSpeed)), -(Float)(MaxPlayerSpeed)));
        
                print("B. Player Speed:X\(_playerSpeedX),Y:\(_playerSpeedY)")
        
        // 3
        var newX = Float64(self.position.x) + (_playerSpeedX*delta);
        var newY = Float64(self.position.y) + (_playerSpeedY*delta);
        
        // 4
        newX = max(Float64(frame.size.width), min(newX, 0));
        newY = max(Float64(frame.size.height), min(newY, 0));
        self.position = CGPoint(x: newX, y: newY)
        
        print("Player Position\(self.position)")
  */
        
        if thrusting
        {
            applyThrust()
        }
        else if reversing
        {
            reverseThrust()
        }
        
        self.physicsBody?.applyTorque(CGFloat(0.5 * delta))
        
        //print("Player\(self))")
    }
}
