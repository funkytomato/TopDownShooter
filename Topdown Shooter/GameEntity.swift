//
//  GameEntity.swift
//  Side Shooter
//
//  Created by cadet on 15/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit

class GameEntity: SKSpriteNode
{
    
    required init?(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint, texture: SKTexture)
    {
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.position = position
    }
    
    func collidedWith(_ body: SKPhysicsBody, contact: SKPhysicsContact) {}
    func update(_ delta: TimeInterval) {}
}
