//
//  ViewController.swift
//  16. Poke3D
//
//  Created by Usama Fouad on 10/11/2021.
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
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images Successfully Added")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = .pi / 2
        
        node.addChildNode(planeNode)
        
        if imageAnchor.referenceImage.name == "eevee-card" {
            let pokeNode = showPokemon(selectedPokemon: "eevee-card")
            planeNode.addChildNode(pokeNode)
        }
        
        if imageAnchor.referenceImage.name == "oddish-card" {
            let pokeNode = showPokemon(selectedPokemon: "oddish-card")
            planeNode.addChildNode(pokeNode)
        }
        
        return node
    }
    
    func showPokemon(selectedPokemon: String) -> SCNNode {
        let scnFile: String!
        if selectedPokemon == "oddish-card" {
            scnFile = "oddish.scn"
        } else {
            scnFile = "eevee.scn"
        }
        if let pokeScene = SCNScene(named: "art.scnassets/\(scnFile!)") {
            if let pokeNode = pokeScene.rootNode.childNodes.first {
                pokeNode.eulerAngles.x = -.pi/2
                return pokeNode
            }
        }
        return SCNNode()
    }
}