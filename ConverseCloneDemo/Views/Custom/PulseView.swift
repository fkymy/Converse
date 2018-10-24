//
//  PulseView.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/19.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

@IBDesignable
final class PulseView: UIView {
  
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
    size.height = 640
    size.width = 640
    return size
  }
  
  lazy var core: Core = {
    let view = Core()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var pulse: Pulse = {
    let view = Pulse()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private func commonInit() {
    backgroundColor = .clear
    
    addSubview(core)
    NSLayoutConstraint.activate([
      core.centerXAnchor.constraint(equalTo: centerXAnchor),
      core.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
    
    insertSubview(pulse, belowSubview: core)
    NSLayoutConstraint.activate([
      pulse.centerXAnchor.constraint(equalTo: centerXAnchor),
      pulse.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
  }
}

@IBDesignable
class Core: UIView {
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
    backgroundColor = UIColor.red
    layer.cornerRadius = 110 / 2
  }
}

@IBDesignable
class Pulse: UIView {
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
    size.height = 156
    size.width = 156
    return size
  }
  
  let innerLayer = CAShapeLayer()
  
  let outerLayer = CAShapeLayer()
  
  let pulseLayer = CAShapeLayer()
  
  private func commonInit() {
    layer.backgroundColor = UIColor.red.cgColor
    layer.opacity = 0.3
    layer.cornerRadius = 156 / 2
    layer.insertSublayer(pulseLayer, below: layer)
    pulseLayer.strokeColor = nil
    pulseLayer.fillColor = UIColor.red.cgColor
    pulseLayer.opacity = 0.3
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    print("LAYOUTSUBVIEWS")

    pulseLayer.frame = self.bounds
    let arcCenter = CGPoint(x: bounds.height / 2, y: bounds.width / 2)
    let startAngle = DegreesToRadians(value: -90)
    let endAngle = DegreesToRadians(value: 270)
    // let radius: CGFloat = (bounds.height / 2) * 1.4
    let radius: CGFloat = 220 / 2
    let path = UIBezierPath(arcCenter: arcCenter,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
    pulseLayer.path = path.cgPath
  }
}

// Helpers
let pi = CGFloat.pi

func DegreesToRadians(value: CGFloat) -> CGFloat {
  return value * pi / 180.0
}

func RadiansToDegrees(value: CGFloat) -> CGFloat {
  return value * 180 / pi
}
