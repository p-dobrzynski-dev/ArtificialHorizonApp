//
//  ViewController.swift
//  ArtificialHorizonApp
//
//  Created by Piotr on 27/03/2020.
//  Copyright © 2020 Piotr. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var artificialHorizonView: ArtificialHorizonView!
    @IBOutlet weak var setOffsetButton: UIButton!
    @IBOutlet weak var resetOffsetButton: UIButton!
    
    private var motionManager = CMMotionManager()
    
    
    override func viewWillAppear(_ animated: Bool) {
        rollLabel.styleLabel()
        pitchLabel.styleLabel()
        
        setOffsetButton.styleButton()
        resetOffsetButton.styleButton()
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Contstans.Colors.backgroundColor)
        
        // Setup artificial horizon view
        
        
        
        startGyrosope()
        startUpdatePitchAndRoll()
    }
    
    @IBAction func setOffsetClicked(_ sender: UIButton) {
        artificialHorizonView.applyOffset()
    }
    
    @IBAction func resetOffsetButton(_ sender: UIButton) {
        artificialHorizonView.resetOffset()
    }
    
    private func startUpdatePitchAndRoll(){
        var timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            DispatchQueue.main.async {
                self.pitchLabel.text = String(format: "Pitch: \n%.2f", self.artificialHorizonView.getPitch())
                self.rollLabel.text = String(format: "Roll: \n%.2f", self.artificialHorizonView.getRoll())
            }
        }
    }
    
    private func startGyrosope(){
        if motionManager.isGyroAvailable {
            
            motionManager.deviceMotionUpdateInterval = 1.0/60;
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
                if let correctData = data{
                    let pitchValue = atan2(-correctData.gravity.z, -correctData.gravity.y)
                    let rollValue = atan2(-correctData.gravity.x, -correctData.gravity.y)
                    DispatchQueue.main.async {
                        self.artificialHorizonView.setPitch(newPitchValue: pitchValue)
                        self.artificialHorizonView.setRoll(newRollValue: rollValue)
                    }
                }
            }
        }
    }
}

extension Double{
    func toDegrees() -> Float {
        return Float(self * 180.0 / Double.pi)
    }
}

extension UILabel{
    func styleLabel(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = self.frame.height/30
    }
}

extension UIButton{
    func styleButton(){
        self.backgroundColor = UIColor(named: Contstans.Colors.insideFrameColor)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}
