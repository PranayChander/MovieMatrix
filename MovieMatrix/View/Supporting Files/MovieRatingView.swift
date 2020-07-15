//
//  MovieRatingView.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieRatingView: UIView {
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.strokeEnd = 1.0
        layer.addSublayer(backgroundLayer)
        return backgroundLayer
    }()
    
    private lazy var trackLayer: CAShapeLayer = {
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = frame.size.width * 0.05
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        return trackLayer
    }()
    
    private lazy var progressLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = frame.size.width * 0.05
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        return progressLayer
    }()
    

    var label = UILabel()
    
    var progressColor = UIColor.green {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    var trackColor = UIColor.darkGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    func makeCircularPath() {
        let backgroundCirclePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        backgroundLayer.path = backgroundCirclePath.cgPath
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2 , y: frame.size.height/2), radius: (frame.size.width * 0.9)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        trackLayer.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
    }
    
    func addRatingLabel(value: Double) {
        label.font = UIFont.systemFont(ofSize: frame.size.height/4,weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "\(Int(value * 100))%"
        addSubview(label)
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Double) {
        addRatingLabel(value: value)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
    }
    
    func setProgress(value: Double, withAnimation: Bool = false, duration: Double = 0.0) {
        if withAnimation {
            label.removeFromSuperview()     
            setProgressWithAnimation(duration: duration, value: value)
        } else {
            addRatingLabel(value: value)
            progressLayer.strokeEnd = CGFloat(value)
        }
    }
}
