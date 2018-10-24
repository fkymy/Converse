//
//  Label.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/19.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

@IBDesignable
class Label: UILabel {
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    if let attributedText = attributedText {
      let t = NSMutableAttributedString(attributedString: attributedText)
      t.addAttribute(NSAttributedString.Key(String(kCTLanguageAttributeName)), value: "ja", range: NSRange(location: 0, length: attributedText.string.utf16.count))
      self.attributedText = t
    }
    else if let text = text {
      attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key(String(kCTLanguageAttributeName)): "ja", .foregroundColor: textColor, .font: font])
    }
  }
}
