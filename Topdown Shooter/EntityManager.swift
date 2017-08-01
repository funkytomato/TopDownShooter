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

struct GameZLayer
{
    static let Background : CGFloat = -30
    static let Lasers : CGFloat      = 0
    static let Particles : CGFloat  = 5
    static let Player : CGFloat     = 10
    static let Asteroids : CGFloat  = 15
    static let HUD : CGFloat        = 30
    
}

class EntityManager
{
    
    
    var moveAndRemoveAsteroid = SKAction()
    var moveAndRemoveLaser = SKAction()
    
    let scene: SKScene
    
    //Scene Layers NOT USED AT THE MO
    let bulletLayerNode = SKNode()
    let particleLayerNode = SKNode()
    

    
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
    func spawnAsteroid(startPosition: CGPoint, categorySize: CategorySize)
    {
        
        
        let randomSpeed = random(min: 0.0, max: 1)
        print("randomSpeed\(randomSpeed)")

        //Random direction
        let randomDx = random(min: -100, max: 100)
        let randomDy = random(min: -100, max: 100)
        print("randomDx\(randomDx)")
        print("randomDy\(randomDy)")
        
        
        let asteroidNode = Asteroid(entityPosition: startPosition, categorySize: categorySize)
        add(asteroidNode)
        
        
        //The Asteroid creation and deletion sequence
        let asteroidDistance = CGFloat(scene.frame.height)
        let asteroidRotation = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: TimeInterval(0.008 * asteroidDistance))
        let moveAsteroid = SKAction.moveBy(x: randomDx + asteroidDistance , y: randomDy + asteroidDistance, duration: TimeInterval(0.008 * asteroidDistance))
        let removeAsteroid = SKAction.removeFromParent()
        
        
        //Group movement and rotation to run sychronously
        let rotateAndMove = SKAction.group([asteroidRotation, moveAsteroid])
        moveAndRemoveAsteroid = SKAction.sequence([rotateAndMove, removeAsteroid])
        
       // asteroidNode.run(moveAndRemoveAsteroid)
        
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
        
        
        guard let node = nodeFiredFrom as? Spaceship else {
            fatalError("Not Spaceship!")
        }

        
        //Define the target point
        let laserDistance = CGFloat(2000)
        let dx = (laserDistance * cos(node.heading()) + node.position.x)
        let dy = (laserDistance * sin(node.heading()) + node.position.y)
        
        
        //Define the start location
        let start = CGFloat(50)
        let dxStart = (start * cos(node.heading()) + node.position.x)
        let dyStart = (start * sin(node.heading()) + node.position.y)
        
        
        //The Laser creation and deletion sequence
        let moveLaser = SKAction.moveBy(x: dx, y: dy, duration: TimeInterval(0.001 * laserDistance))
        let removeLaser = SKAction.removeFromParent()
        moveAndRemoveLaser = SKAction.sequence([moveLaser, removeLaser])
        
        
        //Create the laser and orientate to ship
        let texture = SKTexture(imageNamed: "laserBlue01")
        let laser = SKSpriteNode(texture: texture)
        laser.name = "laser"
        laser.size = CGSize(width: 10, height: 50)
        laser.zRotation = node.zRotation
        laser.zPosition = GameZLayer.Lasers
        laser.position = CGPoint(x: dxStart, y: dyStart)

        
        //Create the physics body
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.allowsRotation = false
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.usesPreciseCollisionDetection = true
        laser.physicsBody?.velocity = CGVector.zero                 //Ensure sprite is not moving before executing SKAction
        
        
        //Define the collision categories
        laser.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Laser
        laser.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.None
        laser.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Alien | PhysicsCollisionBitMask.Asteroid

        
        //Set the laser action running
        laser.run(moveAndRemoveLaser)

        
        add(laser)

    }
    
    
    // Rotates a point (or vector) about the z-axis
    func rotate(vector:CGVector, angle:CGFloat) -> CGVector
    {
        let rotatedX = vector.dx * cos(angle) - vector.dy * sin(angle)
        let rotatedY = vector.dx * sin(angle) + vector.dy * cos(angle)
        return CGVector(dx: rotatedX, dy: rotatedY)
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
