//
//  PrimaryControl.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/19.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class PrimaryControl: Control {
  
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
  
  private func commonInit() {
    backgroundColor = .clear
  }
}

// MARK: Actions
extension PrimaryControl {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sendActions(for: .touchDown)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let touchUpEvent: UIControl.Event = bounds.contains(touch.location(in: self)) ? .touchUpInside : .touchUpOutside
    sendActions(for: touchUpEvent)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    sendActions(for: .touchCancel)
  }
}
