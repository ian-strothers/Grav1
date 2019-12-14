//
//  MenuScene.swift
//  Grav
//
//  Created by ian on 7/14/15.
//  Copyright © 2015 ian. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    let forceManager = ForceManager()
    var balls:[Ball] = []
    let muteSlash = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 5, height: 50))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity.dy = 0 //no gravity
        
        let playGame = Button(text: "Play Game", color: SKColor.blueColor()) { //button to go to game scene
            //send notification to view controller to hide banner ad
            NSNotificationCenter.defaultCenter().postNotificationName("HideAd", object: nil)
            
            let scene = GameScene(size: self.size)
            
            self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
        }
        playGame.position = CGPoint(x: self.frame.midX, y: 3 * self.frame.maxY / 5)
        playGame.name = "Game Button" //for debug identification
        playGame.zPosition = 3
        
        let scores = Button(text: "High Scores", color: SKColor.greenColor()) { //button to go to high score scene
            let scene = ScoresScene(size: self.size)
            
            self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
        }
        scores.position = CGPoint(x: self.frame.midX, y: 2 * self.frame.maxY / 5)
        scores.name = "Scores Button"
        scores.zPosition = 3
        
        let tutorial = Button(text: "Tutorial", color: SKColor.redColor()) { //button to go to tutorial scene
            //send notification to view controller to hide banner ad
            NSNotificationCenter.defaultCenter().postNotificationName("HideAd", object: nil)
            
            let scene = TutorialScene(size: self.size)
            
            self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
        }
        tutorial.position = CGPoint(x: self.frame.midX, y: self.frame.maxY / 5)
        tutorial.name = "Tutorial Button"
        tutorial.zPosition = 3
        
        let mute = Button(img: SKSpriteNode(imageNamed: "Mute")) { //button to turn off sound
            Globals.soundOn = !Globals.soundOn
            NSUserDefaults.standardUserDefaults().setBool(Globals.soundOn, forKey:"Mute")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        mute.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.maxY - 80)
        mute.name = "Mute Button"
        mute.zPosition = 3
        
        muteSlash.position = CGPoint(x: mute.position.x + 16, y: mute.position.y - 16)
        muteSlash.fillColor = SKColor.redColor()
        muteSlash.strokeColor = SKColor.clearColor()
        muteSlash.zRotation = CGFloat(M_PI) / 4
        muteSlash.zPosition = 4
        
        self.addChild(playGame)
        self.addChild(scores)
        self.addChild(tutorial)
        self.addChild(mute)
        self.addChild(muteSlash)
        
        //make balls shoot in pairs toward center of the screen
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(2.0),
            SKAction.runBlock{
                let b1Pos = CGPoint(x: self.frame.width / 2 + CGFloat(arc4random() % 200) - 100, y: self.frame.height / 2 + CGFloat(arc4random() % 200) - 100)
                let b2Pos = CGPoint(x: self.frame.width / 2 + CGFloat(arc4random() % 200) - 100, y: self.frame.height / 2 + CGFloat(arc4random() % 200) - 100)
                
                let ball1 = Ball(pos: b1Pos, charge: (arc4random() % 2 == 0) ? 1 : -1)
                let ball2 = Ball(pos: b2Pos, charge: (arc4random() % 2 == 0) ? 1 : -1)
                
                self.balls.append(ball1)
                self.balls.append(ball2)
                
                self.addChild(ball1)
                self.addChild(ball2)
            }
        ])))
    }
    
    override func willMoveFromView(view: SKView) {
        self.removeAllChildren()
        self.removeFromParent()
    }
    
    override func didChangeSize(oldSize: CGSize) {
        self.childNodeWithName("Game Button")?.position = CGPoint(x: self.frame.midX, y: 3 * self.frame.maxY / 5)
    }
    
    override func update(currentTime: CFTimeInterval) {
        forceManager.handleGravity(balls)
        
        //delete balls as they leave screen
        for var ball:Ball in balls {
            if ball.position.x > self.frame.maxX || ball.position.x < self.frame.minX || ball.position.y > self.frame.maxY || ball.position.y < self.frame.minY { //iff ball is off screen
                balls.removeAtIndex(balls.indexOf(ball)!) //remove from balls array
                ball.removeFromParent() //remove from parent
            }
        }
        
        for ball in balls { //update all balls
            ball.update()
        }
        
        if Globals.soundOn {
            muteSlash.alpha = 0.0
        } else {
            muteSlash.alpha = 1.0
        }
    }
}










