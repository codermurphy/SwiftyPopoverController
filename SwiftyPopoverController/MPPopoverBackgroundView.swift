//
//  MPPopoverBackgroundView.swift
//  qichat
//
//  Created by Qihe_mac on 2020/6/15.
//  Copyright © 2020 Qihe_mac. All rights reserved.
//

import UIKit

class MPPopoverBackgroundView: UIPopoverBackgroundView {
    
    // MARK: - initial methods
    
    override init(frame: CGRect) {

        super.init(frame: frame)

        self.backgroundColor = .clear
        self.layer.shadowOpacity = 0.0
        self.layer.shadowColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.addSubview(self.arrowView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    override class func contentViewInsets() -> UIEdgeInsets {
        return .zero
    }
    
    override class func arrowHeight() -> CGFloat {
        return MPPopoverConfig.arrowHeight
    }
    
    override class func arrowBase() -> CGFloat {
        return MPPopoverConfig.arrowBase
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        set {
            self._arrowDirection = newValue
            self.arrowView.arrowDirection = newValue
        }
        get {
            return self._arrowDirection
        }
        
    }
    
    override var arrowOffset: CGFloat {
        set {
            self._arrowOffset = newValue
        }
        get {
            return self._arrowOffset
        }
        
    }
    
    private var _arrowDirection: UIPopoverArrowDirection = .any
    
    private var _arrowOffset: CGFloat = 0
    
    
    private(set) var arrowView: MPPopoverTriangle =  MPPopoverTriangle(frame: CGRect(x: 0, y: 0, width: MPPopoverConfig.arrowBase, height: MPPopoverConfig.arrowHeight))
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch self.arrowDirection {
        case .up:
            self.arrowView.frame.origin.x = ((self.frame.size.width / 2) + self.arrowOffset) - MPPopoverConfig.arrowBase / 2;
        case .down:
            self.arrowView.frame.origin.x = ((self.frame.size.width / 2) + self.arrowOffset) - MPPopoverConfig.arrowBase / 2;
            self.arrowView.frame.origin.y = self.frame.height - MPPopoverConfig.arrowHeight
        case .left:
            self.arrowView.frame.origin.x = 0
            self.arrowView.frame.origin.y = ((self.frame.size.height / 2) + self.arrowOffset) - MPPopoverConfig.arrowBase / 2;
            self.arrowView.frame.size = CGSize(width: MPPopoverConfig.arrowHeight, height: MPPopoverConfig.arrowBase)
        case .right:
            self.arrowView.frame.origin.x = self.frame.size.width - MPPopoverConfig.arrowHeight
            self.arrowView.frame.origin.y = ((self.frame.size.height / 2) + self.arrowOffset) - MPPopoverConfig.arrowBase / 2;
            self.arrowView.frame.size = CGSize(width: MPPopoverConfig.arrowHeight, height: MPPopoverConfig.arrowBase)

        default:
            break
        }
    }

}

final class MPPopoverTriangle: UIView {
    
    var arrowDirection: UIPopoverArrowDirection = .any
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = MPPopoverConfig.arrowColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        let path = UIBezierPath();
        
        switch self.arrowDirection {
        case .up:
            x = rect.width / 2
            y = 0
            path.move(to:CGPoint(x: x, y: y));
            path.addLine(to:CGPoint(x:0,y: rect.size.height));
            path.addLine(to: CGPoint(x:rect.size.width,y:rect.size.height));
            path.close()
        case .down:
            x = rect.width / 2
            y = rect.height
            path.move(to:CGPoint(x: x, y: y));
            path.addLine(to:CGPoint(x:0,y: 0));
            path.addLine(to: CGPoint(x:rect.size.width,y:0));
            path.close()
        case .left:
            x = 0
            y = rect.height / 2
            path.move(to:CGPoint(x: x, y: y));
            path.addLine(to:CGPoint(x:rect.size.width,y: 0));
            path.addLine(to: CGPoint(x:rect.size.width,y:rect.size.height));
            path.close()
        case .right:
            x = rect.width
            y = rect.height / 2
            path.move(to:CGPoint(x: x, y: y));
            path.addLine(to:CGPoint(x:0,y: 0));
            path.addLine(to: CGPoint(x:0,y:rect.size.height));
            path.close()
        default:
            break
        }
        


        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        self.layer.mask = shapeLayer
    }

}
