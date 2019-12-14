import Foundation
import SpriteKit
import GameKit

class ScoresScene : SKScene {
    override func didMoveToView(view: SKView) {
        //send notification to view controller to show GC leaderboards. will return to menu when done
        NSNotificationCenter.defaultCenter().postNotificationName("ShowLeaderboard", object: nil)
    }
    
    override func willMoveFromView(view: SKView) {
        self.removeAllChildren()
        self.removeFromParent()
    }
}
