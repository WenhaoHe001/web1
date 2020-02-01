//
//  lineView.swift
//  timer
//
//  Created by kevinhe on 2019/11/23.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit

class LineView: UIView {

    var _lineWidth: CGFloat = 15.0 {didSet {setNeedsDisplay()}}
    var color : UIColor = UIColor.yellow {didSet {setNeedsDisplay()}}
    
    
    var lineWidth: CGFloat {
        get {
            return _lineWidth
        }
        
        set {
            if newValue == 3 {
                UIView.transition(with: self, duration: 1.5, options: [.transitionFlipFromLeft], animations: {
                    self._lineWidth = 15
                  })
            } else if newValue == 15 {
                UIView.transition(with: self, duration: 1.5, options: [.transitionFlipFromRight], animations: {
                    self._lineWidth = 3
                  })
            }
            
            
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        backgroundColor = .clear
        let path = UIBezierPath()

        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))

        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
        
    }
    
    
    

}
