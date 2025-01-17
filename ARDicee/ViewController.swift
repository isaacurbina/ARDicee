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
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
		
		let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
		let material = SCNMaterial()
		
		material.diffuse.contents = UIColor.red
		cube.materials = [material]
		
		let node = SCNNode(geometry: cube)
		node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
		
		sceneView.scene.rootNode.addChildNode(node)
		
		sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
		if (ARWorldTrackingConfiguration.isSupported) {
			// Create a session configuration
			let configuration = ARWorldTrackingConfiguration()
			
			print("World Tracking is supported: \(ARWorldTrackingConfiguration.isSupported)")
			print("Body Tracking is supported: \(ARBodyTrackingConfiguration.isSupported)")
			print("Geo Tracking is supported: \(ARGeoTrackingConfiguration.isSupported)")
			
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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
