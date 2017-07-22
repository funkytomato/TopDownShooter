//
//  GameElements.swift
//  Beetle
//
//  Created by Muskan on 1/22/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

import SpriteKit

struct PhysicsCollisionBitMask
{
    static let None: UInt32 = 0x1 << 0
    static let Player:UInt32 = 0x1 << 1
    static let Asteroid:UInt32 = 0x1 << 2
    static let Alien:UInt32 = 0x1 << 3
    static let Laser:UInt32 = 0x1 << 4
}

extension GameScene
{
    

    
    func createSpaceship(startPosition: CGPoint) -> Spaceship
    {
        
        let texture = SKTexture(imageNamed: "spaceflier_01_a")
        let player = Spaceship(entityPosition: startPosition, entityTexture: texture)
        
        return player
    }
    
    func createAsteroid(startPosition: CGPoint) -> Asteroid
    {
 
        let randomNumber = random(min:0, max: 150)
        let randomSize = CGSize(width: randomNumber, height: randomNumber)
        let randomPosition = random(min: 0, max: 500)
        let texture = SKTexture(imageNamed: "asteroid")
 
        let asteroidNode = Asteroid(entityPosition: startPosition, entityTexture: texture, size: randomSize)
        
        return asteroidNode
        
    }
    
    func createAlien(startPosition: CGPoint) -> Alien
    {
        
        
        let randomPosition = random(min: 0, max: 500)
        let texture = SKTexture(imageNamed: "alien_side_green")
        let alien = Alien(entityPosition: startPosition, entityTexture: texture)
        return alien

    }
   
    func createLaser() -> SKNode
    {
        
        let laser = SKSpriteNode(imageNamed: "attack_laser_blue")
        laser.size = CGSize(width: 50, height: 20)
        laser.position = CGPoint(x: player.position.x + 25, y: player.position.y + 420)
        
        laser.physicsBody?.allowsRotation = false
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Laser
        laser.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Alien
        laser.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Alien
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.affectedByGravity = false
        
        laser.zPosition = 0
        
        
        //let randomPosition = random(min: 0, max: 500)
        laser.position.y = player.position.y
        laser.position.x = player.position.x + 10
        
        return laser
    }
    
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat
    {
        return random() * (max - min) + min
    }

}
