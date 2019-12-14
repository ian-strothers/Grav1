import Foundation
import SpriteKit

class Ball: SKNode {
    let ball = SKShapeNode()
    let velocityArrow = SKSpriteNode(imageNamed: "VelocityArrow")
    let charge:Int //+/- 1

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(pos: CGPoint, vel: CGVector, charge:Int) {
        self.charge = charge
        
        super.init()
        
        self.position = pos
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        self.physicsBody!.mass = 2e2 / 2
        self.physicsBody!.velocity = vel
        self.physicsBody!.restitution = 0.1
        self.physicsBody!.contactTestBitMask = 0xF
        self.physicsBody!.categoryBitMask = 0xFF
        self.name = "Ball"
        
        if Globals.soundOn {
            self.runAction(SKAction.playSoundFileNamed("NewBall", waitForCompletion: false))
        }
        
        initBall(pos: pos, vel: vel)
        initVelocityArrow()
    }
    
    convenience init(pos: CGPoint, charge:Int) {
        self.init(pos: pos, vel: CGVector(dx: 0, dy: 0), charge: charge)
    }
    
    func initBall(pos pos: CGPoint, vel: CGVector) {
        //set up the ball
        let circPath = CGPathCreateMutable()
        CGPathAddArc(circPath, nil, 0.0, 0.0, 10.0, 0.0, CGFloat(2 * M_PI), true)
        
        ball.path = circPath
        ball.fillColor = (charge == 1) ? SKColor.redColor() : SKColor.yellowColor()
        ball.lineWidth = 2.0
        ball.strokeColor = SKColor.blackColor()
        ball.zPosition = 2
        
        self.addChild(ball)
    }
    
    func initVelocityArrow() {
        velocityArrow.anchorPoint = CGPoint(x: 0.5, y: 1)
        velocityArrow.size = CGSize(width: 0, height: 0) //initialize arrow with proper aspect ratio
        velocityArrow.zPosition = 1
        
        self.addChild(velocityArrow)
    }
    
    func update() { //update arrow to match ball's velocity
        self.zRotation = 0
        
        //get direction and magnitude of ball's velocity
        let mag = sqrt(pow(self.physicsBody!.velocity.dx, 2) + pow(self.physicsBody!.velocity.dy, 2))
        let dir = atan2(self.physicsBody!.velocity.dy, self.physicsBody!.velocity.dx) + 3.14159265 / 2
        
        velocityArrow.size = CGSize(width: mag / 12.8, height: mag / 4) //adjust arrow to fit magnitude and direction
        velocityArrow.zRotation = dir
    }
}