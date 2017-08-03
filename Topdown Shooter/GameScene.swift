//
//  GameScene.swift
//  Topdown Shooter
//
//  Created by cadet on 20/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    //Encounter Manager
    //It reads in the SKS files, inteprets the scene, creates the objects in code
    var encounterManager: EncounterManager!
    var entityManager: EntityManager!
    
    //var entities = [GKEntity]()
    //var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0

    
    //Player sprites
    var repeatActionPlayer = SKAction()
    var player: Spaceship!
    
    
    //Explosion
    var explosionAtlas: SKTextureAtlas?
    var explosionAction = SKAction()
    
    //Sound
    let backgroundSound = SKAction.playSoundFileNamed("273149__tristan-lohengrin__spaceship-atmosphere-04", waitForCompletion: false)
    let rockFallingSound = SKAction.playSoundFileNamed("381645__alancat__rockfall1b", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("Explosion+9", waitForCompletion: false)
    let alienshipSound = SKAction.playSoundFileNamed("Sci-Fi+Drone", waitForCompletion: false)
    let shootSound = SKAction.playSoundFileNamed("151024__bubaproducer__laser-shot-small-2", waitForCompletion: false)

    //Movement actions
 /*   var moveAndRemoveAlien = SKAction()
    var moveAndRemoveAsteroid = SKAction()
    var moveAndRemoveLaser = SKAction()
 */
    var createAndRemoveExplosion = SKAction()
    
    func loadSceneNodes()
    {
        guard let node = childNode(withName: "player") as? Spaceship else {
            fatalError("Sprite Nodes not loaded")
        }
        self.player = node
    /*
        guard let landBackground = childNode(withName: "landBackground")
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.landBackground = landBackground
        
        guard let objectsTileMap = childNode(withName: "objects")
            as? SKTileMapNode else {
                fatalError("Objects node not loaded")
        }
        self.objectsTileMap = objectsTileMap
 */
    }

    override func sceneDidLoad()
    {
        //print("sceneDidLoad")
        
        //Create physics body for the game world
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self

        self.lastUpdateTime = 0
        
        initaliseExplosionAtlas()

        loadSceneNodes()
        
    }
    

    func initaliseExplosionAtlas()
    {
        ////print("initaliseAlas called")
        
        explosionAtlas = SKTextureAtlas(named:"Explosions")
        
        //Grab the frames from the texture atlas in an array
        //Note:  Check out the syntax explicitly declaring entity frames as an Array
        //SKTextures.  This is not strictly necessary, but it makes the intent of the
        //code more readable
        
        let explosionFrames:[SKTexture] =
            [
                explosionAtlas!.textureNamed("explosion-0"),
                explosionAtlas!.textureNamed("explosion-1"),
                explosionAtlas!.textureNamed("explosion-2"),
                explosionAtlas!.textureNamed("explosion-3"),
                explosionAtlas!.textureNamed("explosion-4"),
                explosionAtlas!.textureNamed("explosion-5"),
                explosionAtlas!.textureNamed("explosion-6"),
                explosionAtlas!.textureNamed("explosion-7"),
                explosionAtlas!.textureNamed("explosion-8"),
                explosionAtlas!.textureNamed("explosion-9"),
                explosionAtlas!.textureNamed("explosion-10"),
                explosionAtlas!.textureNamed("explosion-11"),
                explosionAtlas!.textureNamed("explosion-12"),
                explosionAtlas!.textureNamed("explosion-13"),
                explosionAtlas!.textureNamed("explosion-14"),
                explosionAtlas!.textureNamed("explosion-15"),
                explosionAtlas!.textureNamed("explosion-16"),
                explosionAtlas!.textureNamed("explosion-17"),
                explosionAtlas!.textureNamed("explosion-18"),
                explosionAtlas!.textureNamed("explosion-19"),
                explosionAtlas!.textureNamed("explosion-20"),
                explosionAtlas!.textureNamed("explosion-21"),
                explosionAtlas!.textureNamed("explosion-22"),
                explosionAtlas!.textureNamed("explosion-23")
        ]
        
        //Create a new SKAction to animate between the frames once
        let explosionAnimation = SKAction.animate(with: explosionFrames, timePerFrame: 0.14)
        
        //Create the SKACtion to run the sprite animation repeatedly
        explosionAction = SKAction.repeat(explosionAnimation, count: 1)
        
        //Remove explosion from scene
        let explosionRemoval = SKAction.removeFromParent()
        
        //Group explosion and sound to run sychronously
        let createExplosion = SKAction.group([explosionAction, explosionSound])
        
        //Sequence creation and removal
        createAndRemoveExplosion = SKAction.sequence([createExplosion, explosionRemoval])
        
        //createActions()
    }

    func createExplosion(nodeToExplode: SKNode)
    {
        
        nodeToExplode.run(createAndRemoveExplosion)
    }
 /*
    func createActions()
    {
        //The Alien creation and deletion sequence
        let alienDistance = CGFloat(self.frame.width)
        let moveAlien = SKAction.moveBy(x: -alienDistance - 200, y: 0, duration: TimeInterval(0.008 * alienDistance))
        let removeAlien = SKAction.removeFromParent()
        //moveAndRemoveAlien = SKAction.sequence([alienshipSound, moveAlien, removeAlien])
        moveAndRemoveAlien = SKAction.sequence([moveAlien, removeAlien])
        
        
        //The Asteroid creation and deletion sequence
        let asteroidDistance = CGFloat(self.frame.height)
        let asteroidRotation = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: TimeInterval(0.008 * asteroidDistance))
        let moveAsteroid = SKAction.moveBy(x: 0, y: -asteroidDistance - 100, duration: TimeInterval(0.008 * asteroidDistance))
        let removeAsteroid = SKAction.removeFromParent()
        ////print("asteroid distance\(-asteroidDistance - 100)")
        ////print("asteroid rotation\(-CGFloat.pi * 2)")
        
        //Group movement and rotation to run sychronously
        let rotateAndMove = SKAction.group([asteroidRotation, moveAsteroid])
        //moveAndRemoveAsteroid = SKAction.sequence([rockFallingSound, rotateAndMove, removeAsteroid])
        moveAndRemoveAsteroid = SKAction.sequence([rotateAndMove, removeAsteroid])
        
        
        //The Laser creation and deletion sequence
        let laserDistance = CGFloat(self.frame.width)
        let moveLaser = SKAction.moveBy(x: laserDistance + 50, y: 0, duration: TimeInterval(0.008 * laserDistance))
        let removeLaser = SKAction.removeFromParent()
        moveAndRemoveLaser = SKAction.sequence([moveLaser, removeLaser])

    }
 */   
    func touchDown(atPoint pos : CGPoint)
    {

    }
    
    func touchMoved(toPoint pos : CGPoint)
    {

    }
    
    func touchUp(atPoint pos : CGPoint)
    {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        
        for touch in touches
        {
            let location = touch.location(in: self)
            
            let nodeTouched = nodes(at: location)
            
            for node in nodeTouched
            {
                
                if node.name == "leftBtn"
                {
                    
                    player.isTurningLeft = true
                }
                else if node.name == "rightBtn"
                {
                    player.isTurningRight = true
                }
                else if node.name == "upBtn"
                {
                    player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                }
                else if node.name == "downBtn"
                {
                    player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -100))
                }
                else if node.name == "plusBtn"
                {
                    player.isThrusting = true
                }
                else if node.name == "minusBtn"
                {
                    player.isShooting = true
                    //entityManager.spawnLaser(nodeFiredFrom: player)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
        player.removeAllActions()
        player.isThrusting = false
        player.isReversing = false
        player.isTurningLeft = false
        player.isTurningRight = false
        player.isShooting = false
        
        //Turn the thruster emitter particle effects down
        player.thrusterPlasma?.particleBirthRate = 15

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0)
        {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        
        player.update(dt)
        entityManager.update(dt)

        
        self.lastUpdateTime = currentTime
    }

    override func didMove(to view: SKView)
    {
        entityManager = EntityManager(scene: self)
        encounterManager = EncounterManager(scene: self)

        player.configureSpaceship()
   //     encounterManager.addEncountersToWorld(world: self)
        
        let position = CGPoint.zero
        
        //Create aliens and asteroids
        let spawn = SKAction.run({
            () in
            //self.addChild(self.createAliens())
            self.entityManager.spawnAsteroid(startPosition: position, categorySize: CategorySize.Big)
        })
        
        
        //Main gaame loop
        let delay = SKAction.wait(forDuration: 5)
        let SpawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
        self.run(spawnDelayForever)
    }
  
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        if firstBody.categoryBitMask == PhysicsCollisionBitMask.Laser && secondBody.categoryBitMask == PhysicsCollisionBitMask.Alien   ||
            firstBody.categoryBitMask == PhysicsCollisionBitMask.Alien && secondBody.categoryBitMask == PhysicsCollisionBitMask.Laser
        {
            //Laser hit alien spacecraft
            
            if contact.bodyA.node?.name == "alien"
            {
                contact.bodyA.node?.run(self.explosionAction)
                contact.bodyA.node?.run(self.explosionSound)
            }
            else if contact.bodyB.node?.name == "alien"
            {
                contact.bodyB.node?.run(self.explosionAction)
                contact.bodyB.node?.run(self.explosionSound)
            }
        }
        
        
        if firstBody.categoryBitMask == PhysicsCollisionBitMask.Laser && secondBody.categoryBitMask == PhysicsCollisionBitMask.Asteroid ||
            firstBody.categoryBitMask == PhysicsCollisionBitMask.Asteroid && secondBody.categoryBitMask == PhysicsCollisionBitMask.Laser
        {
            //Laser hit alien spacecraft
            
            if contact.bodyA.node?.name == "asteroid"
            {
                let nodeA = contact.bodyA.node as? Asteroid
                nodeA?.collidedWith(firstBody, contact: contact)
                secondBody.node?.removeFromParent()
                
            }
            else if contact.bodyB.node?.name == "asteroid"
            {
                let nodeB = contact.bodyB.node as? Asteroid
                nodeB?.collidedWith(secondBody, contact: contact)
                firstBody.node?.removeFromParent()

            }
        }
        
        if firstBody.categoryBitMask == PhysicsCollisionBitMask.Player && secondBody.categoryBitMask == PhysicsCollisionBitMask.Asteroid   ||
            firstBody.categoryBitMask == PhysicsCollisionBitMask.Asteroid && secondBody.categoryBitMask == PhysicsCollisionBitMask.Player
        {
            //Player collided with asteroid
            
            //TO DO: - Reduce player's health, animate collision
            
            player.collidedWith(firstBody, contact: contact)
            
        }
        
        
        if firstBody.categoryBitMask == PhysicsCollisionBitMask.Player && secondBody.categoryBitMask == PhysicsCollisionBitMask.Alien   ||
            firstBody.categoryBitMask == PhysicsCollisionBitMask.Alien && secondBody.categoryBitMask == PhysicsCollisionBitMask.Player
        {
            //Player collided with Alien spacecraft
            
            //TO DO: - Player dies, animate collision and alien takeover
            player.collidedWith(firstBody, contact: contact)
        }
        
        
        if firstBody.categoryBitMask == PhysicsCollisionBitMask.Alien && secondBody.categoryBitMask == PhysicsCollisionBitMask.Asteroid   ||
            firstBody.categoryBitMask == PhysicsCollisionBitMask.Asteroid && secondBody.categoryBitMask == PhysicsCollisionBitMask.Alien
        {
            
            //TO DO: - Player dies, animate collision and alien takeover
            //player.collidedWith(firstBody, contact: contact)
            let nodeA = contact.bodyA.node as? Alien
            nodeA?.collidedWith(firstBody, contact: contact)
        }
    }
}
