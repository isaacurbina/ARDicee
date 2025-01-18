//
//  ViewController.swift
//  ARDicee
//
//  Created by Isaac Urbina on 1/17/25.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		sceneView.debugOptions = [.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
		
		
		sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
		if (ARWorldTrackingConfiguration.isSupported) {
			// Create a session configuration
			let configuration = ARWorldTrackingConfiguration()
			configuration.planeDetection = .horizontal
			
			// Run the view's session
			sceneView.session.run(configuration)
		} else {
			print("World tracking is not supported")
		}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor : ARAnchor) {
		if anchor is ARPlaneAnchor {
			let planeAnchor = anchor as! ARPlaneAnchor
			let plane = SCNPlane(
				width: CGFloat(planeAnchor.extent.x),
				height: CGFloat(planeAnchor.extent.z)
			)
			
			let planeNode = SCNNode(geometry: plane)
			planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
			planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
			
			let gridMaterial = SCNMaterial()
			gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
			
			plane.materials = [gridMaterial]
			node.addChildNode(planeNode)
		
		} else {
			return
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.location(in: sceneView)
			let results = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
			
			if let hitResult = results.first {
				let scene = SCNScene(named: "art.scnassets/diceCollada.scn")
				
				if let diceNode = scene?.rootNode.childNode(withName: "Dice", recursively: true) {
					
					diceNode.position = SCNVector3(
						x: hitResult.worldTransform.columns.3.x,
						y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
						z: hitResult.worldTransform.columns.3.z)
					
					sceneView.scene.rootNode.addChildNode(diceNode)
					
					
					diceNode.runAction(
						SCNAction.rotateBy(
							x: CGFloat(getRandomFloat() * getRandomInt()),
							y: CGFloat(getRandomFloat() * getRandomInt()),
							z: CGFloat(getRandomFloat() * getRandomInt()),
							duration: 0.5)
					)
				}
			}
		}
	}
	
	private func getRandomFloat() -> Float {
		return Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
	}
	
	private func getRandomInt() -> Int {
		return Int.random(in: 1...6)
	}
}
