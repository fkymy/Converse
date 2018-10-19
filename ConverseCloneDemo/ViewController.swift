//
//  ViewController.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/10.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

  @IBOutlet weak var container: Container!
  @IBOutlet weak var label: Label!

  @IBOutlet weak var average: UIProgressView!
  @IBOutlet weak var peak: UIProgressView!
  
  private var audioRecorder: AudioRecorder!
  
  private var meterTable = MeterTable(tableSize: 100)
  
  let channelId = "HN2E39kbMSMLQWWC7uTw"
  
  let messageIds = [
    "pGUjibLOnI3sPlStUnqx",
    "RiXlNak2RMyxc9rqkNJK",
    "LqGJnIzyVyT8wEHz2kz4",
    "ZZSLD9CTHB49r35Tg2Ac",
    ]
  
  let messageFilenames = [
    "DCAD51C5-4504-4463-BD46-893EABD4CD6A.m4a",
    "6C1CBE84-A4E3-4BD9-B623-3FBFC5592FB9.m4a",
    "5E1FE449-D907-412E-8534-8CF648DD883F.m4a",
    "CF52E541-19FC-4539-8090-CE7AA3B12CD0.m4a",
    ]

  
  override func viewDidLoad() {
    super.viewDidLoad()
    audioRecorder = AudioRecorder()
    audioRecorder.delegate = self
  }
}

extension ViewController: AudioRecorderDelegate {
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didStartRecording url: URL) {
    // do something
  }
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didStepMetering at: CFTimeInterval, averagePower: Float, peakPower: Float) {
    print("##### didStepMetering \(at) #####")
    
    let linearAverage = meterTable.valueForPower(power: averagePower)
    // let percentageAverage = round(linearAverage * 100)
    // let linearAverage = powf(10, averagePower / 20)
    print("averagePower", averagePower)
    print(linearAverage)
    
    let linearPeak = meterTable.valueForPower(power: peakPower)
    // let percentagePeak = round(linearPeak * 100)
    // let linearPeak = powf(10, peakPower / 20)
    print("peakPower", peakPower)
    print(linearPeak)
    
    label.text = "dB=\(averagePower) lindB=\(linearAverage)"
    average.setProgress(linearAverage, animated: true)
    peak.setProgress(linearPeak, animated: true)
  }
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didFinishRecording url: URL) {
    average.setProgress(0, animated: true)
    peak.setProgress(0, animated: true)
    label.text = "タップ&長押しで話す"
  }
}

// MARK: - IBActions
extension ViewController {
  @IBAction func onTouchDown(_ sender: Any) {
    print("################### onTouchDown")
    audioRecorder.startRecording()
  }
  
  @IBAction func onTouchUpInside(_ sender: Any) {
    print("################### onTouchUpInside")
    audioRecorder.stopRecoding()
  }
  
  @IBAction func onPlay(_ sender: Any) {
    
  }
}
