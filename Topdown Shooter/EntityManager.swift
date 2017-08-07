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
    static let Wall:UInt32 = 0x1 << 6
    static let Shield:UInt32 = 0x1 << 7
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
    
    
    //Game Scene
    let scene: SKScene
    
    
    //Movement actions
    var moveAndRemoveAlien = SKAction()
    var moveAndRemoveAsteroid = SKAction()
    var moveAndRemoveLaser = SKAction()
    var createAndRemoveExplosion = SKAction()

    
    //Scene Layers NOT USED AT THE MO
    let bulletLayerNode = SKNode()
    let particleLayerNode = SKNode()
    

    //Create predefined spawn locations for asteroids
    //Randomise the direction and speed
    var asteroidSpawnLocations : [CGPoint] = []

    
    init(scene: SKScene)
    {
        
        var newStartLocation = CGPoint(x: scene.size.width / 2,y: scene.size.height / 2)
        asteroidSpawnLocations.append(newStartLocation)
        self.scene = scene
    }
    
    func createActions()
    {
        //The Alien creation and deletion sequence
        let alienDistance = CGFloat(scene.frame.width)
        let moveAlien = SKAction.moveBy(x: -alienDistance - 200, y: 0, duration: TimeInterval(0.008 * alienDistance))
        let removeAlien = SKAction.removeFromParent()
        //moveAndRemoveAlien = SKAction.sequence([alienshipSound, moveAlien, removeAlien])
        moveAndRemoveAlien = SKAction.sequence([moveAlien, removeAlien])
        
        /*
        //The Asteroid creation and deletion sequence
        let asteroidDistance = CGFloat(scene.frame.height)
        let asteroidRotation = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: TimeInterval(0.008 * asteroidDistance))
        let moveAsteroid = SKAction.moveBy(x: 0, y: -asteroidDistance - 100, duration: TimeInterval(0.008 * asteroidDistance))
        let removeAsteroid = SKAction.removeFromParent()
        
        //Group movement and rotation to run sychronously
        let rotateAndMove = SKAction.group([asteroidRotation, moveAsteroid])
        //moveAndRemoveAsteroid = SKAction.sequence([rockFallingSound, rotateAndMove, removeAsteroid])
        moveAndRemoveAsteroid = SKAction.sequence([rotateAndMove, removeAsteroid])
        
        
        //The Laser creation and deletion sequence
        let laserDistance = CGFloat(scene.frame.width)
        let moveLaser = SKAction.moveBy(x: laserDistance + 50, y: 0, duration: TimeInterval(0.008 * laserDistance))
        let removeLaser = SKAction.removeFromParent()
        moveAndRemoveLaser = SKAction.sequence([moveLaser, removeLaser])
        */
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
        
        
        scene.enumerateChildNodes(withName: "asteroid", using: ({
            (node, error) in
            let asteroid = node as! Asteroid
            asteroid.update(deltaTime)
        }))

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
     Create and add an asteroid to the given location
     */
    func spawnAsteroid(startPosition: CGPoint, categorySize: CategorySize)
    {
        var spawnPosition = CGPoint.zero
        
        if startPosition == CGPoint.zero
        {
            //let posX = random(min: 0 - scene.size.width, max: scene.size.width)
            //let posY = random(min: 0 - scene.size.width, max: scene.size.height)
            //spawnPosition = CGPoint(x: posX, y: posY)
            
            spawnPosition = asteroidSpawnLocations.first!
        }
        else
        {
            spawnPosition = startPosition
        }
        
        print("spawnPosition: \(spawnPosition)")
        
        let randomSpeed = random(min: 10, max: 1000)
        //print("randomSpeed\(randomSpeed)")
        
        
        let asteroidNode = Asteroid(entityPosition: spawnPosition, categorySize: categorySize)
        add(asteroidNode)
        
        
        let asteroidDistance = CGFloat(scene.frame.width * 2)
        let asteroidDir : CGFloat = randomDirection(minAngle: 180, maxAngle: 275)
        print("asteroidDir:\(asteroidDir)")
        
        asteroidNode.physicsBody?.velocity = (CGVector(dx: cos(asteroidDir) * randomSpeed, dy: sin(asteroidDir) * randomSpeed))
        
        //asteroidNode.physicsBody?.applyForce(CGVector(dx: cos(asteroidDir) * 1000 * randomSpeed, dy: sin(asteroidDir) * 1000 * randomSpeed))
        //print("Force velocity dx:\(cos(asteroidDir) * 1000 * randomSpeed) dy:\(sin(asteroidDir) * 1000 * randomSpeed)")
        
        //The Asteroid creation and deletion sequence
        //let asteroidDistance = CGFloat(scene.frame.width * 2)
        let asteroidRotation = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: TimeInterval(0.008 * asteroidDistance))
        let moveAsteroid = SKAction.moveBy(x: cos(asteroidDir) * 1000, y: sin(asteroidDir) * 1000, duration: TimeInterval(0.008 * asteroidDistance))
        let actionSpeed =  SKAction.speed(by: randomSpeed, duration: 0)
        
        let removeAsteroid = SKAction.removeFromParent()
        
        //print("Asteroid direction dx: \(cos(asteroidDir) * 1000) dy: \(sin(asteroidDir) * 1000)")
        
        //Group movement and rotation to run sychronously
        let rotateAndMove = SKAction.group([asteroidRotation, moveAsteroid])
        moveAndRemoveAsteroid = SKAction.sequence([actionSpeed, rotateAndMove, removeAsteroid])
        
       // asteroidNode.run(moveAndRemoveAsteroid)
        
    }
/*
    /*
     Shoot gun from any angle
    */
    func getAsteroidPath(startPosition: CGPoint)
    {
        let Margin : CGFloat = 20.0;
        
        //CGPoint location = [touch locationInNode:self];
        
        //diff is the destination of asteroid
        CGPoint diff = CGPointMake(location.x - _touchLocation.x, location.y - _float diffLength = sqrtf(diff.x*diff.x + diff.y*diff.y);
        
        float angle = atan2f(diff.y, diff.x);
        _playerMissileSprite.zRotation = angle - SK_DEGREES_TO_RADIANS(90.0f);
        _playerMissileSprite.position = _playerSprite.position;
        _playerMissileSprite.hidden = NO;
        float adjacent, opposite;
        CGPoint destination;
        
        /*
         You have actively divided the screen into four sections, like slices of a pie:
         Each of these sections calculates a slightly different destination point.
         Notice that the code for shooting left comes last, because here you have the
         issue of switching from +180 to -180 degrees again (recall that this is the
         range of values that atan2() returns).
         Now you should be able to fire in any direction! Build and run and give it a
         try.
         */
        if (angle <= -M_PI_4 && angle > -3.0 * M_PI_4)
        {
            // Shoot down
            angle = M_PI_2 - angle;
            adjacent = _playerMissileSprite.position.y + Margin;
            opposite = tanf(angle) * adjacent;
            destination = CGPointMake(_playerMissileSprite.position.x - opposite, -Margin);
        }
        else if (angle > M_PI_4 && angle <= 3.0 * M_PI_4)
        {
            // Shoot up
            angle = M_PI_2 - angle;
            adjacent = _winSize.height - _playerMissileSprite.position.y + Margin;
            opposite = tanf(angle) * adjacent;
            destination = CGPointMake(_playerMissileSprite.position.x + opposite, _winSize.}
        else if (angle <= M_PI_4 && angle > -M_PI_4)
        {
            // Shoot right
            adjacent = _winSize.width - _playerMissileSprite.position.x + Margin;
            opposite = tanf(angle) * adjacent;
            destination = CGPointMake(_winSize.width + Margin, _playerMissileSprite.position.}
    }
        else // angle > 3.0f * M_PI_4 || angle <= -3.0f * M_PI_4
        {
            // Shoot left
            adjacent = _playerMissileSprite.position.x + Margin;
            opposite = tanf(angle) * adjacent;
            destination = CGPointMake(-Margin, _playerMissileSprite.position.y - opposite);
        }
    }
 */
    
    func randomDirection(minAngle: UInt32, maxAngle: UInt32) -> CGFloat
    {

        
        var degrees : UInt32
        var radians : CGFloat
        
        
        degrees = arc4random_uniform(maxAngle - minAngle) + minAngle
        radians = CGFloat(degrees).degreesToRadians()
        
        //print("Radians \(radians) & \(newRadians)")
        
        return radians
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
        let laserDistance = CGFloat(200)
        let dx = (laserDistance * cos(node.heading()))
        let dy = (laserDistance * sin(node.heading()))
        
        
        //Define the start location
        let dxStart = (cos(node.heading()) + node.position.x)
        let dyStart = (sin(node.heading()) + node.position.y)

        
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
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.usesPreciseCollisionDetection = true
        laser.physicsBody?.velocity = CGVector.zero                 //Ensure sprite is not moving before executing SKAction
        
        
        //Define the collision categories
        laser.physicsBody?.categoryBitMask = PhysicsCollisionBitMask.Laser
        laser.physicsBody?.collisionBitMask = PhysicsCollisionBitMask.Asteroid
        laser.physicsBody?.contactTestBitMask = PhysicsCollisionBitMask.Alien | PhysicsCollisionBitMask.Asteroid

        
        //Set the laser action running
        //laser.run(moveAndRemoveLaser)
        
        
        add(laser)

        
        let impulse = CGVector(dx: dx, dy: dy)
        let shipSpeed = node.physicsBody?.velocity
        let laserSpeed = impulse + shipSpeed!
        print("Impulse\(impulse)")
        laser.physicsBody?.applyForce(impulse)
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
