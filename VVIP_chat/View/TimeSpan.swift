//
//  TimeSpan.swift
//  VVIP_chat
//
//  Created by mac on 07/09/21.
//

import UIKit
import Foundation

class TimeSpan: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    private var progress: CGFloat = .pi * 1.5;
    let path = UIBezierPath()
    
    private func anim(){
//        UIView.animate(withDuration: 2) {
//            self.progress = .pi * 5
//        }
    }
    
    //        required init(progress: CGFloat) {
    //            super.init(frame: .zero)
    //            self.progress = progress
    //        }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    //    override init(frame: CGRect) {
    //      super.init(frame: frame)
    //anim()
    //
    //    }
    //
    //    required init(coder aDecoder: NSCoder) {
    //      fatalError("init(coder:) has not been implemented")
    //    }
    
    override func draw(_ rect: CGRect) {
        //        UIView.animate(withDuration: 1) {
        //            self.progress = .pi * 2
        //        }
        createCircularPath()
        progressAnimation(duration: 2.0)
    }
    
    func progressAnimation(duration: TimeInterval) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        progress = .pi * 2
        self.layer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        //            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 10, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        //            // circleLayer path defined to circularPath
        //            circleLayer.path = circularPath.cgPath
        //            // ui edits
        //            circleLayer.fillColor = UIColor.clear.cgColor
        //            circleLayer.lineCap = .round
        //        circleLayer.lineWidth = 2.0
        //            circleLayer.strokeEnd = 1.0
        //            circleLayer.strokeColor = UIColor.white.cgColor
        //            // added circleLayer to layer
        //            layer.addSublayer(circleLayer)
        //            // progressLayer path defined to circularPath
        //            progressLayer.path = circularPath.cgPath
        //            // ui edits
        //
        //            progressLayer.fillColor = UIColor.clear.cgColor
        //            progressLayer.lineCap = .round
        //        progressLayer.lineWidth = 5
        //            progressLayer.strokeEnd = 0
        //            progressLayer.strokeColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        //            // added progressLayer to layer
        //
        //        let rect = CGRect()
        //
        //        let center = CGPoint(x: rect.midX, y: rect.midY)
        //                let radius = min(rect.size.width, rect.size.height) / 2
        //        let endAngle:CGFloat = CGFloat(360 * self.progress)
        let center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center,
                    radius: 10,
                    startAngle: .zero,
                    endAngle: self.progress,
                    clockwise: true)
        UIColor(hexString: "#16a3cc").setFill()
        path.close()
        path.fill()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: 13, startAngle: .zero, endAngle: .pi * 2, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(hexString: "#16a3cc").cgColor
        shapeLayer.lineWidth = 2
        layer.addSublayer(shapeLayer)
        
//        layer.addSublayer(progressLayer)
    }
    
}
