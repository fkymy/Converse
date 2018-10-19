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
    backgroundColor = 
  }
  
  
}
