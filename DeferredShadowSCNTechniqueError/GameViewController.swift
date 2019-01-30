import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        let sphereGeometry = SCNSphere(radius: 1)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position.y = 1.5
        sphereNode.categoryBitMask = 2
        scene.rootNode.addChildNode(sphereNode)
        
        let planeGeometry = SCNPlane(width: 4, height: 4)
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        scene.rootNode.addChildNode(planeNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 5)
        cameraNode.eulerAngles = SCNVector3(-Float.pi / 6, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
        
        let scnView = self.view as! SCNView
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
        
        let dirLight = SCNLight()
        dirLight.type = .directional
        dirLight.castsShadow = true
        dirLight.shadowMode = .deferred
        dirLight.shadowColor = UIColor.black.withAlphaComponent(0.75)
        
        let dirLightNode = SCNNode()
        dirLightNode.light = dirLight
        dirLightNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        
        scnView.scene?.rootNode.addChildNode(dirLightNode)
        
        createTechnique()
    }
    
    func createTechnique() {
        let view = self.view as! SCNView
        
        if let path = Bundle.main.path(forResource: "BasicTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                
                view.technique = technique
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
