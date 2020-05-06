//
//  ArtificialHorizonView.swift
//  ArtificialHorizonApp
//
//  Created by Piotr on 27/03/2020.
//  Copyright © 2020 Piotr. All rights reserved.
//

import UIKit
import Foundation


@IBDesignable class ArtificialHorizonView: UIView {
    
    public var pitch: CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var roll: CGFloat = 0.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var pitchOffset:CGFloat = 0.0
    public var rollOffset:CGFloat = 0.0
    
    
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
        
        let insideBorderLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = insideBorderCirclePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor(named: Contstans.Colors.insideFrameColor)?.cgColor
            shapeLayer.lineWidth = insideBorderWidth
            shapeLayer.shadowColor = UIColor.black.cgColor
            shapeLayer.shadowRadius = 5
            shapeLayer.shadowOffset = .zero
            shapeLayer.shadowOpacity = 0.75
            shapeLayer.allowsEdgeAntialiasing = true
            return shapeLayer
        }()
        
        
        let outsideBorderWidth = bounds.width/50
        
        let outsideBorderCirclePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                   radius: bounds.width/2 - outsideBorderWidth/2,
                                                   startAngle: 0,
                                                   endAngle: 360,
                                                   clockwise: true)
        
        let outsideBorderLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = outsideBorderCirclePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor(named: Contstans.Colors.outsideFrameColor)?.cgColor
            shapeLayer.lineWidth = outsideBorderWidth
            shapeLayer.allowsEdgeAntialiasing = true

            return shapeLayer
        }()
        
        
        
        
        // MARK: - Outside Horizon layouts
        
        // Top
        let topOutsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                 radius: bounds.width/2 - insideBorderWidth,
                                                 startAngle: CGFloat.pi+roll-rollOffset,
                                                 endAngle: roll-rollOffset,
                                                 clockwise: true)
        
        let topOutsideHorizonLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = topOutsideHorizonPath.cgPath
            shapeLayer.fillColor = UIColor(named: Contstans.Colors.topOutsideHorizonColor)?.cgColor
            return shapeLayer
        }()
        
        layer.addSublayer(topOutsideHorizonLayer)
        
        //Bottom
        let bottomOutsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                                    radius: bounds.width/2 - insideBorderWidth,
                                                    startAngle: roll-rollOffset,
                                                    endAngle: CGFloat.pi+roll-rollOffset,
                                                    clockwise: true)
        
        let bottomOutsideHorizonLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bottomOutsideHorizonPath.cgPath
            shapeLayer.fillColor = UIColor(named: Contstans.Colors.bottomOutsideHorizonColor)?.cgColor
            return shapeLayer
        }()
        
        
        layer.addSublayer(bottomOutsideHorizonLayer)
        
        // Line
        let outsideHorizonLinePath: UIBezierPath = {
            let path = UIBezierPath()
            let startLinePoint = CGPoint(x: bounds.midX - cos(roll-rollOffset) * (bounds.width/2 - insideBorderWidth), y: bounds.midY - sin(roll-rollOffset)*(bounds.width/2 - insideBorderWidth))
            path.move(to: startLinePoint)
            let lineEndPoint = CGPoint(x: bounds.midX + cos(roll-rollOffset) * (bounds.width/2 - insideBorderWidth), y: bounds.midY + sin(roll-rollOffset)*(bounds.width/2 - insideBorderWidth))
            path.addLine(to: lineEndPoint)
            path.close()
            return path
        }()
        
        
        
        let outsideHorizonLineLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = outsideHorizonLinePath.cgPath
            shapeLayer.strokeColor = UIColor(named: Contstans.Colors.whiteLineColor)?.cgColor
            shapeLayer.lineWidth = bounds.width/100
            return shapeLayer
        }()
        
        
        layer.addSublayer(outsideHorizonLineLayer)
        
        // MARK: - Inside Horizon layouts
        
        let insideHorizonFrame = CGRect(x: CGFloat(bounds.midX - bounds.width/3), y: CGFloat(bounds.midY - bounds.width/3), width: 2*bounds.width/3, height: 2*bounds.width/3)
        
        
        // Top
        
        let topInsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: insideHorizonFrame.width/2, y: insideHorizonFrame.width/2),
                                                radius: insideHorizonFrame.width/2,
                                                startAngle: CGFloat.pi+pitch-pitchOffset,
                                                endAngle: -(pitch-pitchOffset),
                                                clockwise: true)
        let topInsideHorizonLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = insideHorizonFrame
            shapeLayer.path = topInsideHorizonPath.cgPath
            shapeLayer.transform = CATransform3DRotate(shapeLayer.transform, roll-rollOffset, 0.0, 0.0, 1.0)
            shapeLayer.fillColor = UIColor(named: Contstans.Colors.topInsideHorizonColor)?.cgColor
            return shapeLayer
        }()
        
        // Bottom
        let bottomInsideHorizonLayer = CAShapeLayer()
        bottomInsideHorizonLayer.frame = insideHorizonFrame
        
        let bottomInsideHorizonPath = UIBezierPath(arcCenter: CGPoint(x: insideHorizonFrame.width/2, y: insideHorizonFrame.width/2),
                                                   radius: insideHorizonFrame.width/2,
                                                   startAngle: -(pitch-pitchOffset),
                                                   endAngle: CGFloat.pi+pitch-pitchOffset,
                                                   clockwise: true)
        
        bottomInsideHorizonLayer.path = bottomInsideHorizonPath.cgPath
        bottomInsideHorizonLayer.transform = CATransform3DRotate(bottomInsideHorizonLayer.transform, roll-rollOffset, 0.0, 0.0, 1.0)
        bottomInsideHorizonLayer.fillColor = UIColor(named: Contstans.Colors.bottomInsideHorizonColor)?.cgColor
        
        
        
        // Line
        let insideHorizonLinePath: UIBezierPath = {
            let path = UIBezierPath()
            var angle = pitch-pitchOffset
            if (angle > CGFloat.pi/2 || angle < -CGFloat.pi/2){
                angle = CGFloat.pi - angle
            }
            
            let startPoint = CGPoint(x:insideHorizonFrame.midX - cos(angle)*insideHorizonFrame.width/2 - insideHorizonFrame.width/2,y:insideHorizonFrame.midY - sin(angle)*insideHorizonFrame.width/2)
            path.move(to: startPoint)
            let endPoint = CGPoint(x:insideHorizonFrame.midX + cos(-angle)*insideHorizonFrame.width/2 + insideHorizonFrame.width/2,y:insideHorizonFrame.midY + sin(-angle)*insideHorizonFrame.width/2)
            path.addLine(to: endPoint)
            path.close()
            return path
        }()
        
        let insideHorizonLineLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = insideHorizonFrame
            shapeLayer.bounds = insideHorizonFrame
            shapeLayer.path = insideHorizonLinePath.cgPath
            shapeLayer.strokeColor = UIColor(named: Contstans.Colors.whiteLineColor)?.cgColor
            shapeLayer.transform = CATransform3DRotate(shapeLayer.transform, roll-rollOffset, 0.0, 0.0, 1.0)
            shapeLayer.lineWidth = bounds.width/350
            return shapeLayer
        }()
        
        //Mask for lines
        let maskPath = UIBezierPath(arcCenter: CGPoint(x: insideHorizonFrame.width/2, y: insideHorizonFrame.width/2),
                                    radius: insideHorizonFrame.width/2 - 1,
                                    startAngle: 0,
                                    endAngle: 360,
                                    clockwise: true)
        
        
        let maskLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = insideHorizonFrame
            shapeLayer.path = maskPath.cgPath
            return shapeLayer
        }()
        
        insideHorizonLineLayer.mask = maskLayer
        
        let shadowLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = insideHorizonFrame
            shapeLayer.path = maskPath.reversing().cgPath
            shapeLayer.shadowColor = UIColor.black.cgColor
            shapeLayer.shadowRadius = 5
            shapeLayer.shadowOffset = .zero
            shapeLayer.shadowOpacity = 0.75
            return shapeLayer
        }()
        
        let viewFinderPath: UIBezierPath = {
            let path = UIBezierPath()
            let curveRadius = insideHorizonFrame.width / 10
            path.move(to: CGPoint(x: insideHorizonFrame.minX+2*curveRadius, y: insideHorizonFrame.midY))
            path.addLine(to: CGPoint(x: insideHorizonFrame.midX-curveRadius, y: insideHorizonFrame.midY))
            path.addArc(withCenter: CGPoint(x: insideHorizonFrame.midX, y: insideHorizonFrame.midY), radius: curveRadius, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
            path.addLine(to: CGPoint(x: insideHorizonFrame.maxX-2*curveRadius, y: insideHorizonFrame.midY))
            return path
        }()
        
        let viewFinderShapeLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = insideHorizonFrame
            shapeLayer.bounds = insideHorizonFrame
            shapeLayer.path = viewFinderPath.cgPath
            shapeLayer.strokeColor = UIColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.00).cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = bounds.width/50
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            shapeLayer.shadowRadius = 3
            shapeLayer.shadowOffset = .zero
            shapeLayer.shadowOpacity = 0.5
            shapeLayer.shadowColor = UIColor.black.cgColor
            return shapeLayer
        }()
        
        let centerDotPath: UIBezierPath = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: insideHorizonFrame.midX , y: insideHorizonFrame.midY))
            path.addLine(to: CGPoint(x: insideHorizonFrame.midX , y: insideHorizonFrame.midY))
            return path
        }()
        
        let centerDotShapeLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = insideHorizonFrame
            shapeLayer.bounds = insideHorizonFrame
            shapeLayer.path = centerDotPath.cgPath
            shapeLayer.strokeColor = UIColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.00).cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = bounds.width/50
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            shapeLayer.shadowRadius = 3
            shapeLayer.shadowOffset = .zero
            shapeLayer.shadowOpacity = 0.5
            shapeLayer.shadowColor = UIColor.black.cgColor
            return shapeLayer
        }()
        
        // Adding sublayers
        layer.addSublayer(shadowLayer)
        layer.addSublayer(bottomInsideHorizonLayer)
        layer.addSublayer(topInsideHorizonLayer)
        layer.addSublayer(insideHorizonLineLayer)
        layer.addSublayer(insideBorderLayer)
        layer.addSublayer(outsideBorderLayer)
        layer.addSublayer(viewFinderShapeLayer)
        layer.addSublayer(centerDotShapeLayer)
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



