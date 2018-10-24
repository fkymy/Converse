//
//  MeterTable.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/19.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

// see: https://github.com/shaojiankui/SpeakHere/blob/master/Classes/MeterTable.cpp
// meter table at index 0 returns greatest amplitude
// Memo:
// linear = pow (10, decibels / 20);
// decibels = log10 (linear) * 20;
final class MeterTable {
  
  let minDb: Float = -60.0 // measured in a silent room
  
  var tableSize: Int // 300
  
  let scaleFactor: Float
  
  var meterTable = [Float]()
  
  init (tableSize: Int) {
    self.tableSize = tableSize
    
    let dbResolution = Float(minDb / Float(tableSize - 1))
    scaleFactor = 1.0 / dbResolution
    
    let minAmp = dbToAmp(dB: minDb)
    let ampRange = 1.0 - minAmp
    let invAmpRange = 1.0 / ampRange
    
    for i in 0..<tableSize {
      let decibels = Float(i) * dbResolution
      let amp = dbToAmp(dB: decibels)
      let adjAmp = (amp - minAmp) * invAmpRange
      meterTable.append(adjAmp)
    }
  }
  
  private func dbToAmp(dB: Float) -> Float {
    return powf(10.0, dB / 20)
  }
  
  func valueForPower(power: Float) -> Float {
    if power < minDb {
      return 0.0
    } else if power >= 0.0 {
      return 1.0
    } else {
      let index = Int(power * scaleFactor)
      return meterTable[index]
    }
  }
}
