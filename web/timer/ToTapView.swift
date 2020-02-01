//
//  noName.swift
//  timer
//
//  Created by kevinhe on 2019/11/9.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit


@IBDesignable
class ToTapView: UIView {

    //MARK:- properties
    @IBInspectable var labelText: String = "tap to record🥞!" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable var ovalScale:CGFloat = 13.0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
        
    @IBInspectable var customString: String = "🦴" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable var color: UIColor = UIColor.orange { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable var lineWidth:CGFloat = 33.0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var lineViewlineWidth: CGFloat = 15.0 {
        didSet {
            lineView.lineWidth = lineViewlineWidth
        }
    }
    
    
    lazy private var centerlabel: UILabel = makeLabel()

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsDisplay(); setNeedsLayout()
    }
    
    var centerString: NSAttributedString {
        return centerdAttrubuteString(string: labelText + "\n" + "\n" + customString, fontSize: (superview?.bounds.size.height ?? bounds.size.height) * 0.05)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
//        var color = UIColor(patternImage: <#T##UIImage#>)
        // Drawing code
        backgroundColor = .clear
        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: ovalScale, dy: ovalScale))
        path.lineWidth = 13
        UIColor.orange.setStroke()
        path.stroke()
        
        let linepath = UIBezierPath()

        linepath.move(to: CGPoint.zero)
        linepath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        
        linepath.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        linepath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        linepath.lineWidth = 15.0
        UIColor.green.setStroke()
        linepath.stroke()
        print("view  \(self.contentScaleFactor)")
//        linePath()
//        linePath1()
//        linePath2()
    }
    
     lazy var lineView = self.createLineView()
    
    private func createLineView() -> LineView{
        let lineView = LineView()
        lineView.backgroundColor = .clear
        lineView.isUserInteractionEnabled = false
        lineView.isOpaque = false
        lineView.lineWidth = lineWidth

        return lineView
        
    }
    
//
     func positionLineView() {
        lineView.frame = self.bounds

//        lineView.transform = lineView.transform.rotated(by: bounds.height/bounds.width)
        addSubview(lineView)

    }
        
////        lineView.transform = CGAffineTransform.identity.rotated(by: bounds.height/bounds.width)
       
    //MARK: -lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabel(centerlabel)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        centerlabel.frame.origin = CGPoint(x: center.x - centerlabel.bounds.width/2, y: center.y - centerlabel.bounds.height/2)
                
        positionLineView()
        
    }
    
    
    
    
    //MARK: - label funcs
    
    private func centerdAttrubuteString(string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let pargraphstyle = NSMutableParagraphStyle()
        pargraphstyle.alignment = .center
        return NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.paragraphStyle: pargraphstyle,
            .font: font,
            .strokeColor: UIColor.white
        ])
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.black
        label.alpha = 0.9
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    func configureLabel(_ label: UILabel) {
        label.attributedText = centerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
    }
    
    

}
extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
