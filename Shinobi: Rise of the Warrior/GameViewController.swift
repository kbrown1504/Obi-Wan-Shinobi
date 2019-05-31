//
//  GameViewController.swift
//  Shinobi: Rise of the Warrior
//
//  Created by Keegan Brown on 5/30/19.
//  Copyright © 2019 Keegan Brown. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    
    var isGameOver = false //might need
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    let background = SKSpriteNode(imageNamed: "ninjaBackground")
    let background2 = SKSpriteNode(imageNamed: "background2")
    let background3 = SKSpriteNode(imageNamed: "background3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func onLevelOnePressed(_ sender: UIButton) {
        imageView.isHidden = true
        buttonStackView.isHidden = true
        //sets up scene and displays it
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        //sets up background image
        background.alpha = 0.7
        background.position = CGPoint(x: scene.frame.width / 2 , y: scene.frame.height / 2)
        background.size = CGSize(width: scene.frame.width, height: scene.frame.height)
        scene.addChild(background)
        skView.presentScene(scene)
        
    }
    
    @IBAction func onLevelTwoPressed(_ sender: UIButton) {
        imageView.isHidden = true
        buttonStackView.isHidden = true
        //set up for scene2
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        scene.speedMod = 1.0
        background2.alpha = 0.7
        background2.position = CGPoint(x: scene.frame.width / 2 , y: scene.frame.height / 2)
        background2.size = CGSize(width: scene.frame.width, height: scene.frame.height)
        scene.addChild(background2)
        skView.presentScene(scene)
        
        
    }
    
    @IBAction func onLevelThreePressed(_ sender: UIButton) {
        buttonStackView.isHidden = false
        imageView.isHidden = false
        imageView.isHidden = true
        buttonStackView.isHidden = true
        //set up for scene2
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        scene.speedMod = 2.0
        background3.alpha = 0.7
        background3.position = CGPoint(x: scene.frame.width / 2 , y: scene.frame.height / 2)
        background3.size = CGSize(width: scene.frame.width, height: scene.frame.height)
        scene.addChild(background3)
        skView.presentScene(scene)
    }
    
}


