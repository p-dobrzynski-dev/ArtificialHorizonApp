//
//  ArtificialHorizonView.swift
//  ArtificialHorizonApp
//
//  Created by Piotr on 27/03/2020.
//  Copyright © 2020 Piotr. All rights reserved.
//

import UIKit
import Foundation


class ArtificialHorizonView: UIView {
    
    private var pitch: CGFloat = 0.0
    private var roll: CGFloat = 0.0
    private var pitchOffset:CGFloat = 0.0
    private var rollOffset:CGFloat = 0.0
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        drawArtificalHorizon()
    }
    
    
    
    private func drawArtificalHorizon(){
        
        layer.sublayers = nil
        // MARK: - Border layouts
        let insideBorderWidth = bounds.width / 15
        let insideBorderCirclePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                  radius: bounds.width/2 - insideBorderWidth/2,
                                                  startAngle: 0,
                                                  endAngle: 360,
                                                  clockwise: true)
        
        let insideBorderLayer = CAShapeLayer()
        insideBorderLayer.path = insideBorderCirclePath.cgPath
        insideBorderLayer.fillColor = UIColor.clear.cgColor
        insideBorderLayer.strokeColor = UIColor(named: Contstans.Colors.insideFrameColor)?.cgColor
        insideBorderLayer.lineWidth = insideBorderWidth
        layer.addSublayer(insideBorderLayer)
        
        let outsideBorderWidth = bounds.width/50
        
        let outsideBorderCirclePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                   radius: bounds.width/2 - outsideBorderWidth/2,
                                                   startAngle: 0,
                                                   endAngle: 360,
                                                   clockwise: true)
        
        let outsideBorderLayer = CAShapeLayer()
        outsideBorderLayer.path = outsideBorderCirclePath.cgPath
        outsideBorderLayer.fillColor = UIColor.clear.cgColor
        outsideBorderLayer.strokeColor = UIColor(named: Contstans.Colors.outsideFrameColor)?.cgColor
        outsideBorderLayer.lineWidth = outsideBorderWidth
        
        layer.addSublayer(outsideBorderLayer)
        
        
        // MARK: - Outside Horizon layouts
        
        let topOutsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                 radius: bounds.width/2 - insideBorderWidth,
                                                 startAngle: CGFloat(180+roll-rollOffset).toRadians(),
                                                 endAngle: CGFloat(0+roll-rollOffset).toRadians(),
                                                 clockwise: true)
        
        let topOutsideHorizonLayer = CAShapeLayer()
        topOutsideHorizonLayer.path = topOutsideHorizonPath.cgPath
        topOutsideHorizonLayer.fillColor = UIColor(named: Contstans.Colors.topOutsideHorizonColor)?.cgColor
        layer.addSublayer(topOutsideHorizonLayer)
        
        let bottomOutsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                    radius: bounds.width/2 - insideBorderWidth,
                                                    startAngle: CGFloat(0+roll-rollOffset).toRadians(),
                                                    endAngle: CGFloat(180+roll-rollOffset).toRadians(),
                                                    clockwise: true)
        
        let bottomOutsideHorizonLayer = CAShapeLayer()
        bottomOutsideHorizonLayer.path = bottomOutsideHorizonPath.cgPath
        bottomOutsideHorizonLayer.fillColor = UIColor(named: Contstans.Colors.bottomOutsideHorizonColor)?.cgColor
        layer.addSublayer(bottomOutsideHorizonLayer)
        
        let outsideHorizonLinePath = UIBezierPath()
        
        let startLinePoint = CGPoint(x: bounds.midX - cos((roll-rollOffset).toRadians()) * (bounds.width/2 - insideBorderWidth), y: bounds.midY - sin((roll-rollOffset).toRadians())*(bounds.width/2 - insideBorderWidth))
        outsideHorizonLinePath.move(to: startLinePoint)
        let lineEndPoint = CGPoint(x: bounds.midX + cos((roll-rollOffset).toRadians()) * (bounds.width/2 - insideBorderWidth), y: bounds.midY + sin((roll-rollOffset).toRadians())*(bounds.width/2 - insideBorderWidth))
        outsideHorizonLinePath.addLine(to: lineEndPoint)
        outsideHorizonLinePath.close()
        
        let outsideHorizonLineLayer = CAShapeLayer()
        outsideHorizonLineLayer.path = outsideHorizonLinePath.cgPath
        outsideHorizonLineLayer.strokeColor = UIColor(named: Contstans.Colors.whiteLineColor)?.cgColor
        outsideHorizonLineLayer.lineWidth = bounds.width/100
        
        layer.addSublayer(outsideHorizonLineLayer)
        
        
        
        
        // MARK: - Inside Horizon layouts
        
        let insideHorizonFrame = CGRect(x: CGFloat(bounds.midX - bounds.width/3), y: CGFloat(bounds.midY - bounds.width/3), width: 2*bounds.width/3, height: 2*bounds.width/3)
        
        
        // Top
        let topInsideHorizonLayer = CAShapeLayer()
        topInsideHorizonLayer.frame = insideHorizonFrame
        
        let topInsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: insideHorizonFrame.width/2, y: insideHorizonFrame.width/2),
                                                radius: insideHorizonFrame.width/2,
                                                startAngle: CGFloat(180+pitch-pitchOffset).toRadians(),
                                                endAngle: CGFloat(0-(pitch-pitchOffset)).toRadians(),
                                                clockwise: true)
        
        topInsideHorizonLayer.path = topInsideHorizonPath.cgPath
        topInsideHorizonLayer.transform = CATransform3DRotate(topInsideHorizonLayer.transform, (roll-rollOffset).toRadians(), 0.0, 0.0, 1.0)
        topInsideHorizonLayer.fillColor = UIColor(named: Contstans.Colors.topInsideHorizonColor)?.cgColor
        
        
        // Bottom
        let bottomInsideHorizonLayer = CAShapeLayer()
        bottomInsideHorizonLayer.frame = insideHorizonFrame
        let bottomInsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: insideHorizonFrame.width/2, y: insideHorizonFrame.width/2),
                                                   radius: insideHorizonFrame.width/2,
                                                   startAngle: CGFloat(0-(pitch-pitchOffset)).toRadians(),
                                                   endAngle: CGFloat(180+pitch-pitchOffset).toRadians(),
                                                   clockwise: true)
        
        bottomInsideHorizonLayer.path = bottomInsideHorizonPath.cgPath
        bottomInsideHorizonLayer.transform = CATransform3DRotate(bottomInsideHorizonLayer.transform, (roll-rollOffset).toRadians(), 0.0, 0.0, 1.0)
        bottomInsideHorizonLayer.fillColor = UIColor(named: Contstans.Colors.bottomInsideHorizonColor)?.cgColor
        
        
        
        // Line
        let insideHorizonLineLayer = CAShapeLayer()
        insideHorizonLineLayer.frame = insideHorizonFrame
        insideHorizonLineLayer.bounds = insideHorizonFrame
        let insideHorizonLinePath = UIBezierPath()
        let startInsideLinePoint = CGPoint(x:insideHorizonFrame.midX - cos((pitch-pitchOffset).toRadians())*insideHorizonFrame.width/2 - insideHorizonFrame.width/2,y:insideHorizonFrame.midY - sin((pitch-pitchOffset).toRadians())*insideHorizonFrame.width/2)
        insideHorizonLinePath.move(to: startInsideLinePoint)
        let endInsideLinePoint = CGPoint(x:insideHorizonFrame.midX + cos(-(pitch+pitchOffset).toRadians())*insideHorizonFrame.width/2 + insideHorizonFrame.width/2,y:insideHorizonFrame.midY + sin(-(pitch+pitchOffset).toRadians())*insideHorizonFrame.width/2)
        insideHorizonLinePath.addLine(to: endInsideLinePoint)
        insideHorizonLinePath.close()
        
        insideHorizonLineLayer.path = insideHorizonLinePath.cgPath
        insideHorizonLineLayer.strokeColor = UIColor(named: Contstans.Colors.whiteLineColor)?.cgColor
        insideHorizonLineLayer.transform = CATransform3DRotate(insideHorizonLineLayer.transform, (roll-rollOffset).toRadians(), 0.0, 0.0, 1.0)
        insideHorizonLineLayer.lineWidth = bounds.width/350
        
        
        //Mask for lines
        let maskLayer = CAShapeLayer()
        maskLayer.frame = insideHorizonFrame
        
        let maskPath = UIBezierPath(arcCenter: CGPoint(x: insideHorizonFrame.width/2, y: insideHorizonFrame.width/2),
                                    radius: insideHorizonFrame.width/2 - 1,
                                    startAngle: 0,
                                    endAngle: 360,
                                    clockwise: true)
        maskLayer.path = maskPath.cgPath
        insideHorizonLineLayer.mask = maskLayer
        
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = insideHorizonFrame
        shadowLayer.path = maskPath.reversing().cgPath
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowRadius = 5
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowOpacity = 1
        
        layer.addSublayer(shadowLayer)
        layer.addSublayer(bottomInsideHorizonLayer)
        layer.addSublayer(topInsideHorizonLayer)
        layer.addSublayer(insideHorizonLineLayer)
        
        
    }
    
    func setPitch(newPitchValue pitchValue: Double){
        pitch = CGFloat(pitchValue).toDegrees()
        setNeedsDisplay()
    }
    
    func getPitch() -> Double {
        return Double(pitch)
    }
    
    func setRoll(newRollValue rollValue: Double){
        roll = CGFloat(rollValue).toDegrees()
        setNeedsDisplay()
    }
    
    func getRoll() -> Double {
        return Double(roll)
    }
    
    func applyOffset(){
        pitchOffset = pitch
        rollOffset = roll
    }
    
    func resetOffset(){
        pitchOffset = 0.0
        rollOffset = 0.0
    }
    
}
extension CGFloat{
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
    
    func toDegrees() -> CGFloat {
        return self * 180.0 / CGFloat(Double.pi)
    }
}



