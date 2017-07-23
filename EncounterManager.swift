//
//  SceneManager.swift
//  Game Framework v2
//
//  Created by cadet on 22/06/2017.
//  Copyright © 2017 cadet. All rights reserved.
//

import SpriteKit
import GameplayKit

class EncounterManager
{
    let entityManager: EntityManager!
    
    //Store the encounter file names
    let encounterNames: [String] = ["EncounterSpaceships"]
    
    //Each encounter is an SKNode, store and array
    var encounters:[SKNode] = []
    
    //Keep track of the encounters that can potentially be on the screen at any given time
    var currentEncounterIndex:Int?
    var previousEncounterIndex:Int?
    
    //Reference to Entity Manager
    //var entityManager: EntityManager
    
    init(scene : SKScene)
    {
        entityManager = EntityManager(scene: scene)
        
        //Loop through each encounter scene
        for encounterFileName in encounterNames
        {
            //Create a new node for the encounter
            let encounter = SKNode()
            
            //Load this scene file into a SKScene instance
            if let encounterScene = SKScene(fileNamed: encounterFileName)
            {
                //Loop through each placeholder, spawn the appropriate game object
                for placeholder in encounterScene.children
                {
                    if let node = placeholder as? SKNode
                    {
                        switch node.name!
                        {
                            case "player":
                                entityManager.spawnSpaceship(startPosition: node.position)
                            case "asteroid":
                                entityManager.spawnAsteroid(startPosition: node.position)
                            case "alien":
                                entityManager.spawnAlien(startPosition: node.position)
                            case "ufo":
                                entityManager.spawnUfo(startPosition: node.position)
                            case "laser":
                                entityManager.spawnLaser(nodeFiredFrom: node)

                        default:
                            print("Name error: \node.name)")
                        }
                    }
                }
            }
            
            //Add the populated encounter node to the array
            encounters.append(encounter)
            
            //Save initial sprite positions for this encounter
            saveSpritePositions(node: encounter)
        }
    }
    
    //We will call this addEncountersToWorld function from the GameScene to append all of the encounter
    //nodes to the world node from our GameScene
    func addEncountersToWorld(world:SKScene)
    {
        for index in 0 ... encounters.count-1
        {
            //Spawn the encounters behind the action, with increasing height so they do not collide
            //encounters[index].position = CGPoint(x: -2000, y: index * 1000)
            world.addChild(encounters[index])
        }
    }
    
    //Store the initial positions of the children of a node
    func saveSpritePositions(node:SKNode)
    {
        for sprite in node.children
        {
            if let spriteNode = sprite as? SKSpriteNode
            {
                let initialPositionValue = NSValue(cgPoint:sprite.position)
                spriteNode.userData = ["initialPosition": initialPositionValue]
                //Save the positions for children of this noce
                saveSpritePositions(node: spriteNode)
            }
        }
    }
    
    //Reset all children nodes to their original position
    func resetSpritePositions(node:SKNode)
    {
        for sprite in node.children
        {
            if let spriteNode = sprite as? SKSpriteNode
            {
                //Remove any linear or angular velocity
                spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                spriteNode.physicsBody?.angularVelocity = 0
                
                //Reset the rotation of the sprite
                spriteNode.zRotation = 0
                if let initialPositionValue = spriteNode.userData?.value(forKey: "initialPosition") as? NSValue
                {
                    //Reset the position of the sprite
                    spriteNode.position = initialPositionValue.cgPointValue
                }
                
                //Reset positions on this node's children
                resetSpritePositions(node: spriteNode)
            }
        }
    }
    
    func placeNextEncounter(currentXPos: CGFloat)
    {
        //Count the encounters in a random ready type (UInt32)
        let encounterCount = UInt32(encounters.count)
        
        //The game requires at least 3 encounters to function so exit this function if there are leas than 3
        if encounterCount < 3 { return }
        
        // We need to pick an encoounter that is not currently displayed on the screen
        var nextEncounterIndex: Int?
        var trulyNew: Bool?
        
        //The current encounter and the directly previous encounter can potentially be on the screen at this time.
        //Pick until we get a new encounter
        while trulyNew == false || trulyNew == nil
        {
            //Pick a random encounter to set next
            nextEncounterIndex = Int(arc4random_uniform(encounterCount))
            
            //First, assert that this is a new encounter
            trulyNew = true
            
            //Test if it is instead the current encounter
            if let currentIndex = currentEncounterIndex
            {
                if (nextEncounterIndex == currentIndex)
                {
                    trulyNew = false
                }
            }
            
            //Test if it is the directly previous encounter
            if let previousIndex = previousEncounterIndex
            {
                if (nextEncounterIndex == previousIndex)
                {
                    trulyNew = false
                }
            }
        }
        
        //Keep track of the current encounter
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        
        //Reset the new encounter and position it ahead of the player
        let encounter = encounters[currentEncounterIndex!]
        encounter.position = CGPoint(x: currentXPos + 1000, y: 0)
        resetSpritePositions(node: encounter)
        
    }
}
