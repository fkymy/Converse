//
//  PulseView.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/19.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

@IBDesignable
class PulseView: UIView {
  
  let corePulse = CAShapeLayer()
  
  let innerPulse = CAShapeLayer()
  
  let outerPulse = CAShapeLayer()
  
  @IBInspectable var innerColor: UIColor = Color.Palette.coral
  
  @IBInspectable var innerWidth: CGFloat = 160
  
  @IBInspectable var outerColor: UIColor = Color.Palette.coral
  
  @IBInspectable var outerWidth: CGFloat = 236
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    commonInit()
  }
  
  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    size.height = 110
    size.width = 110
    return size
  }
  
  private func commonInit() {
    layer.cornerRadius = 55
    backgroundColor = Color.Palette.coral
    alpha = 0.9
    
    // innerPulse.fillColor = innerColor.cgColor
    // innerPulse.opacity = 0.6
    // innerPulse.path = UIBezierPath.init(ovalIn: CGRect(x: -25, y: -25, width: 160, height: 160)).cgPath
    // innerPulse.strokeColor = innerColor.cgColor
    
    outerPulse.fillColor = outerColor.cgColor
    // outerPulse.strokeColor = outerColor.cgColor
    outerPulse.opacity = 0.3
    outerPulse.path = UIBezierPath.init(ovalIn: CGRect(x: -63, y: -63, width: 236, height: 236)).cgPath
    
    layer.insertSublayer(innerPulse, below: layer)
    layer.insertSublayer(outerPulse, below: layer)
    // layer.addSublayer(innerPulse)
    // layer.addSublayer(outerPulse)
  }
}
