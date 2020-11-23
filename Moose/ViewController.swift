//  ViewController.swift
//  Moose
//
//  Created by Samuel Brasileiro on 17/11/20.
//

import UIKit
import RealityKit
import SwiftUI
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var isGridBeingShown = false
    
    var planes: [SCNNode] = []
    
    var planeColor: UIColor?
    
    var baseLoaded:Bool = false
    
    var bankView: UIHostingController<ContentView>?

    var bank = PaintingsBank()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
            
        planeColor = UIColor.yellow.withAlphaComponent(0.0)
        //set scene view to automatically add omni directional light when needed
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        bankView = UIHostingController(rootView: ContentView(bank: bank))
        
        bankView?.view.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(bankView!.view)
        bankView!.view.backgroundColor = .clear
        let constraints = [
            bankView!.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            bankView!.view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            bankView!.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            bankView!.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            bankView!.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)

        // Add the box anchor to the scene
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        sceneView.session.run(configuration)
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
        
        addTapGestureToSceneView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(withGestureRecognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    

    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        print("Tap")
        let tapLocation = recognizer.location(in: sceneView)
        //get a 3D point from the tapped location
        //check if the user tapped an existing plane
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !bank.isCardOpen{
            print("Trying to add object")
            //check if there was a result to the hit test
            guard let hitTest = hitTestResults.first, let _ = hitTest.anchor else {
                return
            }
            
            addPortrait(hitTest)
        }
        else{
            bank.isCardOpen = false
            bank.cardPosition = UIScreen.main.bounds.height - 120
            print("aaaaaaa")
        }
    }
    func addPortrait(_ hitTest: ARHitTestResult){
        guard let image = bank.selectedPaintings.last else{
            return
        }
        bank.selectedPaintings.removeAll()
        
        var height = image.size.height
        var width = image.size.width
        print(height, "/", width)
        repeat{
            height /= 2
            width /= 2
        } while width > 1 || height > 1
        
        let planeGeometry = SCNPlane(width: width, height: height)
        
        let material = SCNMaterial()
        material.diffuse.contents = image
        
        planeGeometry.materials = [material]
        
        
        let imageNode = SCNNode(geometry: planeGeometry)
        
        //match the image transform to the hit test anchor transform
        imageNode.transform = SCNMatrix4(hitTest.anchor!.transform)
        
        //rotate the node so it stands up vertically, rather than lying flat
        imageNode.eulerAngles = SCNVector3(imageNode.eulerAngles.x + (-1 * .pi / 2), imageNode.eulerAngles.y, imageNode.eulerAngles.z)
        
        //position node using the hit test
        imageNode.position = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
        
        //add image to scene
        sceneView.scene.rootNode.addChildNode(imageNode)
        
    }
    

}


//MARK: ARSCN View Delegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else {return}

        //update the plane node, as plane anchor information updates

        //get the width and the height of the planeAnchor
        let w = CGFloat(planeAnchor.extent.x)
        let h = CGFloat(planeAnchor.extent.z)

        //set the plane to the new width and height
        plane.width = w
        plane.height = h

        //get the x y and z position of the plane anchor
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)

        //set the nodes position to the new x,y, z location
        planeNode.position = SCNVector3(x, y, z)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        //add a plane node to the scene

        //get the width and height of the plane anchor
        let w = CGFloat(planeAnchor.extent.x)
        let h = CGFloat(planeAnchor.extent.z)

        //create a new plane
        let plane = SCNPlane(width: w, height: h)

        //set the color of the plane
        plane.materials.first?.diffuse.contents = planeColor!

        //create a plane node from the scene plane
        let planeNode = SCNNode(geometry: plane)

        //get the x, y, and z locations of the plane anchor
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)

        //set the plane position to the x,y,z postion
        planeNode.position = SCNVector3(x,y,z)

        //turn th plane node so it lies flat vertically, rather than stands up vertically
        planeNode.eulerAngles.x = -.pi / 2

        //set the name of the plane
        planeNode.name = "plane"

        //add plane to scene
        node.addChildNode(planeNode)
        
        //save plane (so it can be edited later)
        planes.append(planeNode)
    }
    
    
    
}
