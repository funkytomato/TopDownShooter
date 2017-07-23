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
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //Player sprites
    //let spaceshipAtlas = SKTextureAtlas(named:"Spaceship")
    //var playerSprites = Array<SKTexture>()
    var repeatActionPlayer = SKAction()
    var player: Spaceship!
    
    //Scene Layers
    //let bulletLayerNode = SKNode()
    //let particleLayerNode = SKNode()
    
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
    var moveAndRemoveAlien = SKAction()
    var moveAndRemoveAsteroid = SKAction()
    var moveAndRemoveLaser = SKAction()
    var createAndRemoveExplosion = SKAction()
    
    override func sceneDidLoad()
    {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self

        // Create entity manager
        entityManager = EntityManager(scene: self)
        encounterManager = EncounterManager(scene: self)

        //let texture = SKTexture(imageNamed: "Spaceship")
        //let startPosition = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
//        player = Spaceship(entityPosition: startPosition, entityTexture: texture)
//        addChild(player)
        
        self.lastUpdateTime = 0

    }
    
    func playerNode() -> Spaceship
    {
        let node = entityManager.scene.childNode(withName: "player")! as! Spaceship
        //print("node:\(node)")
        
        return node
        //return entityManager.scene.childNode(withName: "spaceship")! as! Spaceship
    }
    
    func initaliseExplosionAtlas()
    {
        //print("initaliseAlas called")
        
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
        
        //Group explosion and sound to run sychronously
        createAndRemoveExplosion = SKAction.group([explosionAction, explosionSound])
        
        createActions()
    }

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
        //print("asteroid distance\(-asteroidDistance - 100)")
        //print("asteroid rotation\(-CGFloat.pi * 2)")
        
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
    
    func touchDown(atPoint pos : CGPoint)
    {
        if let n = self.spinnyNode?.copy() as! SKShapeNode?
        {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint)
    {
        if let n = self.spinnyNode?.copy() as! SKShapeNode?
        {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
        if let n = self.spinnyNode?.copy() as! SKShapeNode?
        {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
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
                    playerNode().physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    playerNode().physicsBody?.applyImpulse(CGVector(dx: -100, dy: 0))
                }
                else if node.name == "rightBtn"
                {
                    playerNode().physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    playerNode().physicsBody?.applyImpulse(CGVector(dx: 100, dy: 0))
                }
                else if node.name == "upBtn"
                {
                    playerNode().physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    playerNode().physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                }
                else if node.name == "downBtn"
                {
                    playerNode().physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    playerNode().physicsBody?.applyImpulse(CGVector(dx: 0, dy: -100))
                }
                else if node.name == "plusBtn"
                {

                }
                else if node.name == "minusBtn"
                {

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
        
        
        self.lastUpdateTime = currentTime
    }

    override func didMove(to view: SKView)
    {
        encounterManager.addEncountersToWorld(world: self)
    }
}
