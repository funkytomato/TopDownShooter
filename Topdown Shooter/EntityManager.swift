//
//  EntityManager.swift
//  Game Framework
//
//  Created by cadet on 20/06/2017.
//  Copyright © 2017 cadet. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

/*
 The EntityManager functions are used when encounters are being read from a SKS file.
 */

struct PhysicsCollisionBitMask
{
    static let None: UInt32 = 0x1 << 0
    static let Player:UInt32 = 0x1 << 1
    static let Asteroid:UInt32 = 0x1 << 2
    static let Alien:UInt32 = 0x1 << 3
    static let Laser:UInt32 = 0x1 << 4
    static let Ufo:UInt32 = 0x1 << 5
}

class EntityManager
{
    let scene: SKScene
    
    init(scene: SKScene)
    {
        self.scene = scene
    }
    
    //Add Entity to the game world
    func add(_ entity: SKNode)
    {
        scene.addChild(entity)

    }
    
    //Remove Entity from the game world
    func remove(_ entity: SKNode)
    {
        entity.removeFromParent()
    }
    
    func update(_ deltaTime: CFTimeInterval)
    {
        //Only applicable for updating GKEntity
    }
    
    /*
    Create and add a spaceship to the location specified by the SKS file.
    */
    func spawnSpaceship(startPosition: CGPoint)
    {
        let texture = SKTexture(imageNamed: "Spaceship")
        let spaceship = Spaceship(entityPosition: startPosition, entityTexture: texture)
        add(spaceship)
    }
    
    /*
     Create and add an asteroid to the location specified by the SKS file.
     */
    func spawnAsteroid(startPosition: CGPoint)
    {
        
        let randomNumber = random(min:0, max: 150)
        let randomSize = CGSize(width: randomNumber, height: randomNumber)

        let texture = SKTexture(imageNamed: "asteroid")
        let asteroidNode = Asteroid(entityPosition: startPosition, entityTexture: texture, size: randomSize)
        add(asteroidNode)
    }
    
    /*
     Create and add an alien to the location specified by the SKS file.
     */
    func spawnAlien(startPosition: CGPoint)
    {
        let texture = SKTexture(imageNamed: "alien_side_green")
        let alien = Alien(entityPosition: startPosition, entityTexture: texture)
        add(alien)
    }
    
    /*
     Create and add an alien to the location specified by the SKS file.
     */
    func spawnUfo(startPosition: CGPoint)
    {
        let texture = SKTexture(imageNamed: "ufoBlue")
        let ufo = Alien(entityPosition: startPosition, entityTexture: texture)
        add(ufo)
    }
    
    /*
     Create and add a laser to the location specified by the SKS file.
     */
    func spawnLaser(nodeFiredFrom: SKNode)
    {
        
        let laser = SKSpriteNode(imageNamed: "laserBlue01")
        laser.size = CGSize(width: 50, height: 20)
        laser.position = CGPoint(x: nodeFiredFrom.position.x + 25, y: nodeFiredFrom.position.y + 420)
        
        laser.physicsBody?.allowsRotation = false
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Laser
        laser.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Alien
        laser.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Alien
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.affectedByGravity = false
        
        laser.zPosition = 0
        
        
        //let randomPosition = random(min: 0, max: 500)
        laser.position.y = nodeFiredFrom.position.y
        laser.position.x = nodeFiredFrom.position.x + 10
        
        add(laser)
    }
    
    /*
    Random functions used for position and size
    */
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat
    {
        return random() * (max - min) + min
    }

}
