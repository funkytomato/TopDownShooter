//
//  Health.swift
//  Side Shooter
//
//  Created by cadet on 18/07/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import SpriteKit

class HealthBar : SKNode
{
    
    let fullHealth: CGFloat
    var health: CGFloat
    var healthBar: SKShapeNode?
    
    let soundAction = SKAction.playSoundFileNamed("smallHit.wav", waitForCompletion: false)
    
    override init()
    {
        self.fullHealth = 100
        self.health = 100
        
        super.init()
    }
    
    init(size: CGSize, barOffset: CGFloat)
    {
        
        self.fullHealth = 100
        self.health = 100

        healthBar = SKShapeNode(rectOf: CGSize(width: size.width, height: 5), cornerRadius: 5)
        healthBar?.fillColor = UIColor.green
        healthBar?.strokeColor = UIColor.green
        healthBar?.position = CGPoint(x: 0.5, y: barOffset)
        
        healthBar?.isHidden = false
 
        super.init()
        
        addChild(healthBar!)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isAlive() -> Bool
    {
        if health > 0
        {
            return true
        }
        
        return false
    }
    
    func currentHealth() -> CGFloat
    {
        return health
    }
    
    @discardableResult func takeDamage(_ damage: CGFloat) -> Bool
    {
        health = max(health - damage, 0)
        
        healthBar?.isHidden = false
        let healthScale = health/fullHealth
        let scaleAction = SKAction.scaleX(to: healthScale, duration: 0.5)
        let fadeAction = SKAction.fadeOut(withDuration: 1.0)
        healthBar?.run(SKAction.group([soundAction, scaleAction, fadeAction]))
        
/*        if health == 0
        {
            if entity != nil
            {
                
            }
        }
        */
        return health == 0
        
    }
    
}
