import SpriteKit
import GameKit

class PlayAgainScene : SKScene {
    var score:Int?
    let scoreText = SKLabelNode(fontNamed: "HoeflerText-BlackItalic")
    
    //send player's score to gameCenter if available
    func reportScore() {
        if Globals.gcEnabled {
            let scorePackage = GKScore(leaderboardIdentifier: Globals.LBID) //score package to sent to leaderboard
            scorePackage.value = Int64(score!) //set value to player's score
        
            GKScore.reportScores([scorePackage]) {(error:NSError?) in //send score with handler for errors
                if let e = error {
                    print("\(e.localizedDescription)") //just log the error
                }
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        score = self.userData!.objectForKey("Score") as? Int //get scene data
        
        scoreText.text = "Score: \(score!)" //text to display score
        scoreText.fontSize = 80
        scoreText.color = SKColor.redColor()
        scoreText.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        
        reportScore()
        
        let playAgainButton = Button(text: "Play Again", color: SKColor.blueColor()) {
            let scene = GameScene(size: self.size)
            
            self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
        }
        playAgainButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        playAgainButton.name = "Play Again Button"
        
        let menuButton = Button(text: "Back To Menu", color: SKColor.greenColor()) {
            //send notification to view controller to show ad
            NSNotificationCenter.defaultCenter().postNotificationName("ShowAd", object: nil)
            
            let scene = MenuScene(size: self.size)
            
            self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
        }
        menuButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        menuButton.name = "Back To Menu Button"
        
        self.addChild(scoreText)
        self.addChild(playAgainButton)
        self.addChild(menuButton)
        
        //send notification to view controller to present interstitial at death
        NSNotificationCenter.defaultCenter().postNotificationName("PresentInterstitial", object: nil)
    }
    
    override func willMoveFromView(view: SKView) {
        self.removeAllChildren()
        self.removeFromParent()
    }
}
