//
//  Colors.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/19.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

struct Color {
  struct Palette {
    /// #F26161
    static let coral = #colorLiteral(red: 0.9490196078, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
    /// #41424E
    static let black = #colorLiteral(red: 0.2549019608, green: 0.2588235294, blue: 0.3058823529, alpha: 1)
    /// #828290
    static let gray = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5647058824, alpha: 1)
    /// #DADBE3
    static let lightGray = #colorLiteral(red: 0.8549019608, green: 0.8588235294, blue: 0.8901960784, alpha: 1)
    /// #F7F8FA
    static let snowWhite = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
    /// #1EBD7D
    static let green = #colorLiteral(red: 0.1176470588, green: 0.7411764706, blue: 0.4901960784, alpha: 1)
    /// #FFB44A
    static let yellow = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.2901960784, alpha: 1)
    /// #6585C2
    static let blue = #colorLiteral(red: 0.3960784314, green: 0.5215686275, blue: 0.7607843137, alpha: 1)
  }
}

// Temporary
extension UIColor {
  
  //  static var primary: UIColor {
  //    return UIColor(red:1.00, green:0.32, blue:0.32, alpha:0.84)
  //  }
  
  static var primary: UIColor {
    return UIColor(red:0.58, green:0.82, blue:0.79, alpha:1.0)
  }
  
  static var prompting: UIColor {
    return UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
  }
  
  static var recording: UIColor {
    return UIColor(red:1.00, green:0.15, blue:0.00, alpha:1.0)
  }
  
  static var disabled: UIColor {
    return UIColor.lightGray
  }
}
