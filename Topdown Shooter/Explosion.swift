//
//  Explosion.swift
//  Topdown Shooter
//
//  Created by cadet on 29/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit

class Explosion: SKNode
{
    //Explosion
    var explosionAtlas: SKTextureAtlas?
    var explosionAction = SKAction()
    
    let explosionSound = SKAction.playSoundFileNamed("Explosion+9", waitForCompletion: false)

    var createAndRemoveExplosion = SKAction()
    
    
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
    }
    
    func createExplosion(nodeToExplode: SKNode)
    {
        
        nodeToExplode.run(createAndRemoveExplosion)
    }
}
