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
        
    func spawnSpaceship(startPosition: CGPoint)
    {
        let texture = SKTexture(imageNamed: "Spaceship")
        let spaceship = Spaceship(entityPosition: startPosition, entityTexture: texture)
        add(spaceship)
    }
}
