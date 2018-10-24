//
//  PrimaryControl.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/19.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

protocol PrimaryControlDelegate: class {
  
  func primaryControl(_ primaryControl: PrimaryControl, didBeginTouch touch: UITouch)
  
  func primaryControl(_ primaryControl: PrimaryControl, didMoveTouch touch: UITouch)
  
  func primaryControl(_ primaryControl: PrimaryControl, didEndTouch touch: UITouch)
  
  func primaryControl(_ primaryControl: PrimaryControl, didCancelTouch touch: UITouch)
}

final class PrimaryControl: Control {
  
  weak var delegate: PrimaryControlDelegate?
  
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
    guard let touch = touches.first else { return }
    sendActions(for: .touchDown)
    delegate?.primaryControl(self, didBeginTouch: touch)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let dragEvent: UIControl.Event = bounds.contains(touch.location(in: self)) ? .touchDragInside : .touchDragOutside
    sendActions(for: dragEvent)
    delegate?.primaryControl(self, didMoveTouch: touch)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let touchUpEvent: UIControl.Event = bounds.contains(touch.location(in: self)) ? .touchUpInside : .touchUpOutside
    sendActions(for: touchUpEvent)
    delegate?.primaryControl(self, didEndTouch: touch)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    sendActions(for: .touchCancel)
    delegate?.primaryControl(self, didCancelTouch: touch)
  }
}
