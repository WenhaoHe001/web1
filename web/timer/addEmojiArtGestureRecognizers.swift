//
//  File.swift
//  demo-emojiArt4
//
//  Created by kevinhe on 2018/11/29.
//  Copyright © 2018 kevinhe. All rights reserved.
//

import UIKit

// Gesture Recognition Extension to EmojiArtView
extension UITextView
{
    func addEmojiArtGestureRecognizers(to view: UIView) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectSubview(by:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.selectAndMoveSubview(by:))))

    }
//    func addDeleteButton(_ view:UIView){
//        print("addDeleteButton")
//        let button = UIButton()
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        button.backgroundColor = .blue
//        button.center =  CGPoint(x: view.frame.maxX, y: view.frame.minY)
//        button.addTarget(self, action: #selector(deleteView(_:)), for: UIControl.Event.touchUpInside)
//        view.addSubview(button)
//    }
//
//    @objc func deleteView(_ view: UIView){
//        print("deleteView")
//        view.removeFromSuperview()
//    }
    
    
    var selectedSubview: UIView? { //UIView
        get { return subviews.filter { $0.layer.borderWidth > 0 }.first }
        set {
            subviews.forEach { $0.layer.borderWidth = 0 }
            
            newValue?.layer.borderWidth = 5
            self.resignFirstResponder()
            
            if newValue != nil {
                insertSubview(newValue!, at: subviews.count-1)
                print("newValue")
                enableRecognizers()
            } else {
                print("newValue?")
                disableRecognizers()
            }
        }
    }
    
    @objc func selectSubview(by recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            selectedSubview = recognizer.view
            print("recognizer")
        }
    }
    
    @objc func selectAndMoveSubview(by recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if selectedSubview != nil, recognizer.view != nil {
                selectedSubview = recognizer.view
            }
        case .changed, .ended:
            if selectedSubview != nil {
                recognizer.view?.center = recognizer.view!.center.offset(by: recognizer.translation(in: self))
                print("selectedSubview")
                recognizer.setTranslation(CGPoint.zero, in: self)
                if recognizer.state == .ended {
//                    delegate?.emojiArtViewDidChange(self)
//                    delegate?.textViewDidEndEditing?(self)
                }
            }
        default:
            break
        }
    }
    
    func enableRecognizers() {
        if let scrollView = superview as? UIScrollView {
            // if we are in a scroll view, disable its recognizers
            // so that ours will get the touch events instead
            print("enableRecognizers")
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
//        if let superView = self as? UITextView {
//            // if we are in a scroll view, disable its recognizers
//            // so that ours will get the touch events instead
//            superView.panGestureRecognizer.isEnabled = false
//            superView.pinchGestureRecognizer?.isEnabled = false
//            print("UITextView enableRecognizers")
//        }
        
        if gestureRecognizers == nil || gestureRecognizers!.count == 0 {
             print("1")
            addGestureRecognizer(UITapGestureRecognizer(target: superview ?? self, action: #selector(self.deselectSubview)))
            addGestureRecognizer(UIPinchGestureRecognizer(target: superview ?? self, action: #selector(self.resizeSelectedLabel(by:))))
        } else {
            print("2")
            gestureRecognizers?.forEach { $0.isEnabled = true }
        }
    }
    
    func disableRecognizers() {
        if let scrollView = superview as? UIScrollView {
            // if we are in a scroll view, re-enable its recognizers
            scrollView.panGestureRecognizer.isEnabled = true
            scrollView.pinchGestureRecognizer?.isEnabled = true
            print("disableRecognizers")

        }
        if let scrollView = superview as? UITextView {
            // if we are in a scroll view, re-enable its recognizers
            scrollView.panGestureRecognizer.isEnabled = true
            scrollView.pinchGestureRecognizer?.isEnabled = true
            print(" UITextView disableRecognizers")

        }
        gestureRecognizers?.forEach { $0.isEnabled = false }
    }
    
    @objc func deselectSubview() {
        selectedSubview = nil
    }
    
    @objc func resizeSelectedLabel(by recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            print("resizeSelectedLabel")
            if let label = selectedSubview as? UILabel {
                print("label")
                label.attributedText = label.attributedText?.withFontScaled(by: recognizer.scale)
                label.stretchToFit()
                recognizer.scale = 1.0
                if recognizer.state == .ended {
                //delegate?.emojiArtViewDidChange(self)
                }
            }
            if let imageView = selectedSubview as? UIImageView {
                print("imageView")
                imageView.image = imageView.image?.scaled(by: recognizer.scale)
                let oldcenter = imageView.center
                imageView.sizeToFit()
                imageView.center = oldcenter
                recognizer.scale = 1.0
                if recognizer.state == .ended {
                    //delegate?.emojiArtViewDidChange(self)
                }
            }
        default:
            break
        }
    }
    
    @objc func selectAndSendSubviewToBack(by recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let view = recognizer.view, let index = subviews.firstIndex(of: view) {
                selectedSubview = view
                exchangeSubview(at: 0, withSubviewAt: index)
//                delegate?.emojiArtViewDidChange(self)
            }
        }
    }
}
