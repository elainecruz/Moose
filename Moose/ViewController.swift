//
//  ViewController.swift
//  Moose
//
//  Created by Samuel Brasileiro on 17/11/20.
//

import UIKit
import RealityKit
import SwiftUI

class ViewController: UIViewController {
    
    //@IBOutlet var arView: ARView!
    
    var artistsHost: UIHostingController<SwiftUIView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        
            //let boxAnchor = try PaintingE.loadCena()
            //PaintingE.Cena().frame
            //arView.scene.anchors.append(boxAnchor)
        
        artistsHost = UIHostingController(rootView: SwiftUIView(bank: PaintingsBank()))
        artistsHost?.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(artistsHost!.view)
        artistsHost!.view.backgroundColor = .clear
        let constraints = [
            artistsHost!.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            artistsHost!.view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            artistsHost!.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            artistsHost!.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            artistsHost!.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
        
        // Add the box anchor to the scene
        
    }
}
