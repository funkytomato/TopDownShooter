//
//  Asteroid.swift
//  Side Shooter
//
//  Created by cadet on 18/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import Foundation

import SpriteKit

// Asteroids are categorised into size
// When an asteroid is hit, it breaks down into asteroids the next size down, until small, and then remove!
enum CategorySize
{
    case Big
    case Medium
    case Small
    case Tiny
}



class Asteroid: GameEntity
{
    
    var categorySize : CategorySize
    
    let asteroidDust = SKEmitterNode(fileNamed: "asteroidDust")
    
    required init?(coder aDecoder: NSCoder)
    {
        categorySize = .Big
        super.init(coder:aDecoder)
    }
    
//    init(entityPosition: CGPoint, entityTexture: SKTexture, size: CGSize)
    init(entityPosition: CGPoint, entityTexture: SKTexture, categorySize: CategorySize)
    {
        
        //var asteroidSize = AsteroidCategory.Tiny
        var texture : SKTexture!
 
        switch categorySize
        {
            case .Big:
                texture = SKTexture(imageNamed: "meteorBrown_big1")
            
            case .Medium:
                texture = SKTexture(imageNamed: "meteorBrown_med1")
            
            case .Small:
                texture = SKTexture(imageNamed: "meteorBrown_small1")
            
            case .Tiny:
                texture = SKTexture(imageNamed: "meteorBrown_tiny1")
            
        }
        
  
  //      let texture = SKTexture(imageNamed: "meteorBrown_big1")
        self.categorySize = categorySize
        
        
        super.init(position:entityPosition, texture: texture)
        self.name = "asteroid"
        self.size = texture.size()
        self.position = entityPosition
        self.color = SKColor.blue
        self.zPosition = GameZLayer.Asteroids
        
        asteroidDust!.isHidden = true
        addChild(asteroidDust!)
        
        configureCollisionBody()
        
    }
    
    
    func configureCollisionBody()
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.0)
        self.zRotation = 2.0
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 1
        self.physicsBody?.restitution = (self.size.width + self.size.height / 2) / 100
        //print("Asteroid Restitution:\((self.size.width + self.size.height / 2) / 100)")
        
        //Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
        self.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Asteroid
        
        //Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
        self.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Player
        
        //Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
        self.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Player | PhysicsCollisionBitMask.Alien | PhysicsCollisionBitMask.Laser

    }
   
    
    /*
     Breakup asteroid into smaller pieces
     */
    func breakupAsteroid(categorySize: CategorySize)
    {

        
        //get current asteroid position and velocity
        let parentPosition  = self.position
        
        //create new smaller asteroid
        let mainScene = scene as! GameScene
        mainScene.entityManager.spawnAsteroid(startPosition: parentPosition, categorySize: categorySize)
        mainScene.entityManager.spawnAsteroid(startPosition: parentPosition, categorySize: categorySize)
        mainScene.entityManager.spawnAsteroid(startPosition: parentPosition, categorySize: categorySize)
        
        mainScene.entityManager.remove(self)
    }
    
    override func collidedWith(_ body: SKPhysicsBody, contact: SKPhysicsContact)
    {
        
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        
        if bodyA == "spaceship" ||
            bodyB == "spaceship"
        {

        }
        else if bodyA == "alien" ||
            bodyB == "alien"
        {
        }
        else if bodyA == "laser" ||
            bodyB == "laser"
        {
            
            let rockSize = self.categorySize
            
            switch rockSize
            {
                case .Big:
                    breakupAsteroid(categorySize: CategorySize.Medium)
                    break
                case .Medium:
                    breakupAsteroid(categorySize: CategorySize.Small)
                    break
                case .Small:
                    breakupAsteroid(categorySize: CategorySize.Tiny)
                    break
                case .Tiny:
                    let mainScene = scene as! GameScene
                    mainScene.entityManager.remove(self)
                    break
            }
         /*
            guard let node = contact.bodyA.node as? Asteroid else {
                fatalError("Not Asteroid!")
            }
           */
 
            asteroidDust!.isHidden = false
        }
    }
}
