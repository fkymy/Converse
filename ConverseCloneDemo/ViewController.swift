//
//  ViewController.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/10.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {

  @IBOutlet weak var primaryControl: PrimaryControl!
  
  @IBOutlet weak var container: Container!
  
  @IBOutlet weak var label: Label!

  private var pulseView: PulseView!
  
  private var audioRecorder: AudioRecorder!
  
  private var meterTable = MeterTable(tableSize: 100)
  
  private var isPulsating = false
  
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
    primaryControl.delegate = self
    setupViews()
  }
  
  private func setupViews() {
    pulseView = PulseView()
    pulseView.isHidden = true
    pulseView.alpha = 0
    view.addSubview(pulseView)
  }
}

// MARK: - Audio Recorder Delegate
extension ViewController: AudioRecorderDelegate {
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didStartRecording url: URL) {
    // do something
  }
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didStepMetering at: CFTimeInterval, averagePower: Float, peakPower: Float) {
    guard isPulsating, let pulseView = pulseView else {
      return
    }
    
    let linearAverage = meterTable.valueForPower(power: averagePower)
    let linearPeak = meterTable.valueForPower(power: peakPower)
    print("##### didStepMetering \(at) #####")
    print("averagePower", averagePower)
    print(linearAverage)
    print("peakPower", peakPower)
    print(linearPeak)
    
    label.text = "dB=\(averagePower)\n lindB=\(linearAverage)"
    
    let scale: CGFloat = CGFloat(1 + (linearAverage * 10))
    print("scale", scale)

    // pulseView.transform = CGAffineTransform.identity
    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
      pulseView.pulse.transform = CGAffineTransform(scaleX: scale, y: scale)
    })
  }
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didFinishRecording url: URL) {
    
  }
}

// MARK: - Primary Control Delegate
extension ViewController: PrimaryControlDelegate {
  
  func primaryControl(_ primaryControl: PrimaryControl, didBeginTouch touch: UITouch) {
    let location = touch.location(in: primaryControl)
    pulseView.center = location

    beginPulsation(withDuration: 0.2) { [weak self] in
      let impact = UIImpactFeedbackGenerator(style: .heavy)
      impact.impactOccurred()
      // self?.audioRecorder.startRecording()
    }
  }
  
  func primaryControl(_ primaryControl: PrimaryControl, didMoveTouch touch: UITouch) {
    let location = touch.location(in: primaryControl)
    pulseView.center = location
  }
  
  func primaryControl(_ primaryControl: PrimaryControl, didEndTouch touch: UITouch) {
    if audioRecorder.isRecording {
      audioRecorder.stopRecoding()
    }
    endPulsation()
  }
  
  func primaryControl(_ primaryControl: PrimaryControl, didCancelTouch touch: UITouch) {
    if audioRecorder.isRecording {
      audioRecorder.stopRecoding()
    }
    endPulsation()
  }
}

// MARK: - Primary Animations
extension ViewController: CAAnimationDelegate {
  
  func beginPulsation(withDuration: TimeInterval, _ completion: @escaping () -> Void) {
    pulseView.isHidden = false
    pulseView.alpha = 1.0
    pulseView.layer.removeAllAnimations()
    
    let animationGroup = CAAnimationGroup()
    animationGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
    animationGroup.duration = withDuration
    animationGroup.fillMode = .forwards
    animationGroup.isRemovedOnCompletion = true
    animationGroup.delegate = self
    
    let alphaAnimation = CABasicAnimation(keyPath: "opacity")
    alphaAnimation.fromValue = 0.0
    alphaAnimation.toValue = 1.0
    
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.fromValue = 0.0
    scaleAnimation.toValue = 2.0
    
    animationGroup.animations = [alphaAnimation, scaleAnimation]
    
    pulseView.layer.add(animationGroup, forKey: nil)
    
//    let spikeDuration = withDuration / 4
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + withDuration) {
//      completion()
//      UIView.animate(withDuration: spikeDuration, delay: 0, options: .curveLinear, animations: {
//        self.pulseView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//      }) { _ in
//        UIView.animate(withDuration: spikeDuration, delay: 0, options: .curveEaseOut, animations: {
//          self.pulseView.transform = CGAffineTransform.identity
//        })
//      }
//    }
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag == true {
      let impact = UIImpactFeedbackGenerator(style: .heavy)
      impact.impactOccurred()
      spikePulsation()
      
      // audioRecorder.startRecording()
    }
    else {
      
    }
  }
  
  func spikePulsation() {

  }
  
  func endPulsation() {
    pulseView.layer.removeAllAnimations()
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.duration = 0.2
    scaleAnimation.fromValue = pulseView.transform
    scaleAnimation.toValue = 0.0
    scaleAnimation.isRemovedOnCompletion = true
    scaleAnimation.fillMode = .forwards
    pulseView.layer.add(scaleAnimation, forKey: "scale")
    pulseView.isHidden = true
    pulseView.alpha = 0.0
  }
}

// MARK: - Utilities
extension ViewController {
  
  func launchHaptic() {
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    impact.impactOccurred()
  }
}
