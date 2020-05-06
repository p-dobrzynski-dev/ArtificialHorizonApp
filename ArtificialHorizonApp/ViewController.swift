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
        
        view.backgroundColor = UIColor(named: Contstans.Colors.backgroundColor)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setup artificial horizon view
        startGyrosope()
        startUpdatePitchAndRoll()
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender {
        case setOffsetButton:
            artificialHorizonView.applyOffset()
        case resetOffsetButton:
            artificialHorizonView.resetOffset()
        default:
            return
        }
        sender.backgroundColor = UIColor.init(named: Contstans.Colors.insideFrameColor)
    }
    
    @IBAction func buttonHold(_ sender: UIButton) {
        sender.backgroundColor = UIColor.init(named: Contstans.Colors.outsideFrameColor)
    }
    
    
    private func startUpdatePitchAndRoll(){
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            DispatchQueue.main.async {
                self.pitchLabel.text = String(format: "Pitch: \n%.2f", self.artificialHorizonView.pitch.toDegrees()-self.artificialHorizonView.pitchOffset.toDegrees())
                self.rollLabel.text = String(format: "Roll: \n%.2f", self.artificialHorizonView.roll.toDegrees()-self.artificialHorizonView.rollOffset.toDegrees())
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
                        self.artificialHorizonView.pitch = CGFloat(pitchValue)
                        self.artificialHorizonView.roll = CGFloat(rollValue)
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
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.75
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
}
