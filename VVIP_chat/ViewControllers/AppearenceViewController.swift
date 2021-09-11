//
//  AppearenceViewController.swift
//  VVIP_chat
//
//  Created by mac on 20/08/21.
//

import UIKit

class AppearenceViewController: UIViewController {
    @IBOutlet var changeTheme: UIButton!
    @IBOutlet weak var navItem: UINavigationBar!
    @IBOutlet weak var ellipsis: UIBarButtonItem!
    
    var box = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    var box1 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    var box2 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxConfig(box: box)
        boxConfig(box: box1)
        boxConfig(box: box2)
        //        let rect = RectFramer(withView: view)
        //        print(rect)
        //        drawLineIn(withRectRef: rect)
        //        let path = addQuadCurve(to: CGPoint.zero, controlPoint: CGPoint(x: 100, y: 200))
        //        box.draw(CGRect())
        //        box.addBottomRoundedEdge(desiredCurve: 5)
        //        box1 = backView()
        rightMenuConfig()
    }
    
    @IBAction func changeThemeTapped(_ sender: Any) {
        self.view.backgroundColor = Constants.themeColor
    }
    
    @IBAction func changeTap(_ sender: Any) {
        self.view.backgroundColor = Constants.themeColor
        self.navigationController?.navigationBar.backgroundColor = .red
//        self.navItem.backgroundColor = .red
//        navItem.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
//        navItem.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
//        navItem.barTintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        box.backgroundColor = .red
    }
    
    private func selectBoxConfig(){
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("box1", comment: ""), image: UIImage(systemName: "bell"), handler: {_ in
                self.box.backgroundColor = .red
            }),
            UIAction(title: NSLocalizedString("box2", comment: ""), image: UIImage(systemName: "bell"), handler: {_ in
                self.box.backgroundColor = .green
            }),
            UIAction(title: NSLocalizedString("box3", comment: ""), image: UIImage(systemName: "bell"), handler: {_ in
                self.box.backgroundColor = .blue
            }),
        ])
        ellipsis.menu = barButtonMenu
    }
    
    private func rightMenuConfig(){
        let barButtonMenu = UIMenu(title: "", children: [
//            UIAction(title: NSLocalizedString("Red", comment: ""), handler: {_ in
//                self.box.backgroundColor = .red
//            }),
            UIAction(title: NSLocalizedString("Light", comment: ""), handler: {_ in
//                self.box.backgroundColor = .green
                self.view.window?.overrideUserInterfaceStyle = .light

            }),
            UIAction(title: NSLocalizedString("Dark", comment: ""), handler: {_ in
//                self.box.backgroundColor = .blue
                self.view.window?.overrideUserInterfaceStyle = .dark
            }),
        ])
        ellipsis.menu = barButtonMenu
    }
    
    func boxConfig(box:UIView){
        box.layer.shadowOffset = CGSize(width: 10, height: 10)
        box.layer.shadowColor = UIColor.yellow.cgColor
        box.layer.shadowRadius = 10
        box.layer.shadowOpacity = 0.5
        box.layer.opacity = 0.8
        box.backgroundColor = .yellow
        box.center = self.view.center
        //        box.layer.transform.m12 = 1
        //        box.layer.transform.m21 = 1
        box.layer.transform = CATransform3D(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1)
        
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        text.text = box.frame.size.height.description
        text.textAlignment = .center
        //        text.translatesAutoresizingMaskIntoConstraints = false
        //        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        text.tintColor = .black
        box.addSubview(text)
        self.view.addSubview(box)
        
        self.view.addSubview(box1)
        self.view.addSubview(box2)
        
//                let option: UIView.AnimationOptions = [.transitionCurlUp, .repeat, .autoreverse]
//
//                UIView.animate(withDuration: 5, delay: 0, options: option) { [self] in
//        //            box.frame.origin.y += box.frame.size.height
//                    self.box.frame.size = CGSize(width: 300, height: 50)
//                    text.frame.size = box.frame.size
//                    text.transform = text.transform.scaledBy(x: 0.1, y: 0.1)
//                    box.backgroundColor = .cyan
//        //            box.layer.shadowColor = UIColor.blue.cgColor
//                    box.layer.shadowOpacity = 0.1
//                    box.layer.opacity = 0.1
//        //            box.layer.transform.m11 = 5
//        //            box.layer.transform.m12 = 0
//        //            box.layer.transform.m21 = 0.5
//        //            box.layer.transform = CATransform3D(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 0, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
//                    box.transform = box.transform.rotated(by: .pi)
//                }
        
        box.isUserInteractionEnabled = true
        box.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggedView)))
        box1.isUserInteractionEnabled = true
        box1.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggedView1)))
        box2.isUserInteractionEnabled = true
        box2.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggedView2)))
    }
    
    @objc func draggedView(sender:UIPanGestureRecognizer){
        print(sender.state.rawValue)
        self.view.bringSubviewToFront(box)
        if sender.state == .began {
            // Save the view's original position.
            let translation = sender.translation(in: self.box)
            box.center = CGPoint(x: box.center.x + translation.x, y: box.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
        // Update the position for the .began, .changed, and .ended states
        if sender.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let translation = sender.translation(in: self.box)
            box.center = CGPoint(x: box.center.x + translation.x, y: box.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
        //        if sender.state != .ended {
        //           // Add the X and Y translation to the view's original position.
        ////         let translation = sender.translation(in: self.box)
        //         box.center = CGPoint(x: box.center.x, y: box.center.y)
        //         sender.setTranslation(CGPoint.zero, in: self.view)           }
        else {
            // On cancellation, return the piece to its original location.
            box.center = CGPoint(x: view.center.x, y: view.center.y)
        }
    }
    
    @objc func draggedView1(sender:UIPanGestureRecognizer){
        print(sender.state.rawValue)
        self.view.bringSubviewToFront(box1)
        if sender.state == .began {
            // Save the view's original position.
            let translation = sender.translation(in: self.box1)
            box1.center = CGPoint(x: box1.center.x + translation.x, y: box1.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
            
        }
        // Update the position for the .began, .changed, and .ended states
        if sender.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let translation = sender.translation(in: self.box1)
            box1.center = CGPoint(x: box1.center.x + translation.x, y: box1.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)           }
        //        if sender.state != .ended {
        //           // Add the X and Y translation to the view's original position.
        ////         let translation = sender.translation(in: self.box)
        //         box1.center = CGPoint(x: box1.center.x, y: box1.center.y)
        //         sender.setTranslation(CGPoint.zero, in: self.view)           }
        else {
            // On cancellation, return the piece to its original location.
            box1.center = CGPoint(x: view.center.x, y: view.center.y)
        }
    }
    
    @objc func draggedView2(sender:UIPanGestureRecognizer){
        print(sender.state.rawValue)
        self.view.bringSubviewToFront(box2)
        if sender.state == .began {
            // Save the view's original position.
            let translation = sender.translation(in: self.box2)
            box2.center = CGPoint(x: box2.center.x + translation.x, y: box2.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
            
        }
        // Update the position for the .began, .changed, and .ended states
        if sender.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let translation = sender.translation(in: self.box2)
            box2.center = CGPoint(x: box2.center.x + translation.x, y: box2.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)           }
        //        if sender.state != .ended {
        //           // Add the X and Y translation to the view's original position.
        ////         let translation = sender.translation(in: self.box)
        //         box2.center = CGPoint(x: box2.center.x, y: box2.center.y)
        //         sender.setTranslation(CGPoint.zero, in: self.view)           }
        else {
            // On cancellation, return the piece to its original location.
            box2.center = CGPoint(x: view.center.x, y: view.center.y)
            
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIView {
    
    /* Usage Example
     * bgView.addBottomRoundedEdge(desiredCurve: 1.5)
     */
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
    }
}

class BrezerPath: UIView{
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.maxX+5, y: rect.minY))//a
        
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))//b
        bezierPath.addLine(to: CGPoint(x: rect.maxX-10, y: 10))//c
        bezierPath.addLine(to: CGPoint(x: rect.maxX-10, y: rect.maxY-5))//d
        bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX-15, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX-10, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX-15, y: rect.maxY))//e
        bezierPath.addLine(to: CGPoint(x:rect.minX+5, y:rect.maxY))//f
        bezierPath.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY-5), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY-5))//g
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY+5))//h
        bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+5, y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.minX+5, y: rect.minY))//i
        
        UIColor.blue.setFill()
        
        bezierPath.fill()
        bezierPath.close()
    }
}

class layers: UIView{
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: frame.height/2))
        //        path.addCurve(to: CGPoint.zero, controlPoint1: CGPoint(x: self.frame.width/2, y: -100), controlPoint2: CGPoint(x: self.frame.width, y: self.frame.height/2))
        ////        path.addCurve(to: CGPoint.zero, controlPoint1: CGPoint(x: self.frame.width/2, y: -100), controlPoint2: CGPoint(x: self.frame.width/2, y: self.frame.height/2))
        //        path.addClip()
        //        path.addQuadCurve(to: CGPoint(x: self.frame.width/2, y: self.frame.height), controlPoint: CGPoint(x: self.frame.width/2, y: 0))
        //        path.addQuadCurve(to: CGPoint(x: self.frame.width, y: self.frame.height), controlPoint: CGPoint(x: self.frame.width/2, y: self.frame.height/2))
        path.addCurve(to: CGPoint(x: self.frame.width, y: self.frame.height/2), controlPoint1: CGPoint(x: self.frame.width/3, y: -self.frame.height/10), controlPoint2: CGPoint(x: self.frame.width/2, y: self.frame.height))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        //        UIColor.systemPink.withAlphaComponent(0.5).setFill()
        let shapeMask1 = CAShapeLayer()
        shapeMask1.path = path.cgPath
        
        let gradient1 = CAGradientLayer()
        gradient1.frame = path.bounds
        gradient1.colors = [UIColor(hexString: "8D6E63").cgColor, UIColor(hexString: "4E342E").cgColor]
        gradient1.mask = shapeMask1
        self.layer.addSublayer(gradient1)
        
        path.close()
        path.fill()
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: frame.height/3))
        //        path.addCurve(to: CGPoint.zero, controlPoint1: CGPoint(x: self.frame.width/2, y: -100), controlPoint2: CGPoint(x: self.frame.width, y: self.frame.height/2))
        ////        path.addCurve(to: CGPoint.zero, controlPoint1: CGPoint(x: self.frame.width/2, y: -100), controlPoint2: CGPoint(x: self.frame.width/2, y: self.frame.height/2))
        //        path.addClip()
        //        path.addQuadCurve(to: CGPoint(x: self.frame.width/2, y: self.frame.height), controlPoint: CGPoint(x: self.frame.width/2, y: 0))
        //        path.addQuadCurve(to: CGPoint(x: self.frame.width, y: self.frame.height), controlPoint: CGPoint(x: self.frame.width/2, y: self.frame.height/2))
        path1.addCurve(to: CGPoint(x: self.frame.width, y: self.frame.height/3), controlPoint1: CGPoint(x: self.frame.width/3, y: -self.frame.height/3), controlPoint2: CGPoint(x: self.frame.width/2, y: self.frame.height))
        path1.addLine(to: CGPoint(x: frame.width, y: 0))
        path1.addLine(to: CGPoint(x: 0, y: 0))
        //        UIColor.red.withAlphaComponent(0.5).setFill()
        let shapeMask = CAShapeLayer()
        shapeMask.path = path1.cgPath
        
        let gradient = CAGradientLayer()
        gradient.frame = path1.bounds
        gradient.colors = [UIColor(hexString: "795548").cgColor, UIColor(hexString: "3E2723").cgColor]
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
        
        path1.close()
        path1.fill()
    }
}
