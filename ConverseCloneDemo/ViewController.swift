//
//  ViewController.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/10.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

final class ViewController: UIViewController {
  
  @IBOutlet weak var primaryControl: PrimaryControl!
  
  @IBOutlet weak var container: Container!
  
  @IBOutlet weak var label: Label!
  
  private var pulseView: PulseView!
  
  private var audioRecorder: AudioRecorder!
  
  private var meterTable = MeterTable(tableSize: 100)
  
  private var isPulsating = false
  
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
    print("audioRecorder didStartRecording")
  }
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didStepMetering at: CFTimeInterval, averagePower: Float, peakPower: Float) {
    guard let pulseView = pulseView else {
      return
    }
    
    let linearAverage = meterTable.valueForPower(power: averagePower)
    let scale = CGFloat(1 + (linearAverage * 5))
    
    label.text = "dB=\(averagePower)\n \(linearAverage)"
    
    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
      pulseView.pulse.transform = CGAffineTransform(scaleX: scale, y: scale)
    })
  }
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didFinishRecording url: URL) {
    let impact = UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred()
    label.text = "タップ&長押しで話す"
  }
}

// MARK: - Primary Control Delegate
extension ViewController: PrimaryControlDelegate {
  
  func primaryControl(_ primaryControl: PrimaryControl, didBeginTouch touch: UITouch) {
    let location = touch.location(in: primaryControl)
    pulseView.center = location
    beginCompression()
    beginPulsation()
  }
  
  func primaryControl(_ primaryControl: PrimaryControl, didMoveTouch touch: UITouch) {
    let location = touch.location(in: primaryControl)
    pulseView.center = location
  }
  
  func primaryControl(_ primaryControl: PrimaryControl, didEndTouch touch: UITouch) {
    if audioRecorder.isRecording {
      audioRecorder.stopRecoding()
    }
    endCompression()
    endPulsation()
  }
  
  func primaryControl(_ primaryControl: PrimaryControl, didCancelTouch touch: UITouch) {
    if audioRecorder.isRecording {
      audioRecorder.stopRecoding()
    }
    endCompression()
    endPulsation()
  }
}

// MARK: - Primary Animations
extension ViewController: CAAnimationDelegate {
  
  func beginCompression() {
    UIView.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseIn, animations: {
      self.container.layer.cornerRadius = 32
      self.container.transform = CGAffineTransform(scaleX: 0.925, y: 0.925)
    })
  }
  
  func endCompression() {
    container.layer.removeAllAnimations() // this fixes a jump
    container.transform = CGAffineTransform.identity
    container.layer.cornerRadius = 0
//    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
//      self.container.transform = CGAffineTransform.identity
//      self.container.layer.cornerRadius = 0
//    })
  }
  
  func beginPulsation() {
    pulseView.isHidden = false
    pulseView.alpha = 1.0
    pulseView.layer.removeAllAnimations()
    
    let launchGroup = CAAnimationGroup()
    launchGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
    launchGroup.duration = 0.25
    launchGroup.fillMode = .forwards
    launchGroup.delegate = self
    
    let alphaAnimation = CABasicAnimation(keyPath: "opacity")
    alphaAnimation.fromValue = 0.0
    alphaAnimation.toValue = 1.0
    
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.fromValue = 0.0
    scaleAnimation.toValue = 2
    
    launchGroup.animations = [alphaAnimation, scaleAnimation]
    
    let dampAnimation = CABasicAnimation(keyPath: "transform.scale")
    dampAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    dampAnimation.beginTime = CACurrentMediaTime() + 0.25
    dampAnimation.duration = 0.1
    dampAnimation.fromValue = 2
    dampAnimation.toValue = 1
    
    pulseView.layer.add(launchGroup, forKey: nil)
    pulseView.layer.add(dampAnimation, forKey: nil)
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag == true {
      print("flag is true")
      
      AudioServicesPlaySystemSound(1519)
      audioRecorder.startRecording()
    }
    else {
      print("flag is false")
    }
  }
  
  func endPulsation() {
    pulseView.layer.removeAllAnimations()
    //    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    //    scaleAnimation.duration = 0.2
    //    scaleAnimation.fromValue = pulseView.transform
    //    scaleAnimation.toValue = 0.0
    //    scaleAnimation.isRemovedOnCompletion = true
    //    scaleAnimation.fillMode = .forwards
    //    pulseView.layer.add(scaleAnimation, forKey: "scale")
    pulseView.isHidden = true
    pulseView.alpha = 0.0
  }
  
  private func beginAnimation() -> CAAnimation {
    let animation = CAKeyframeAnimation()
    animation.keyPath = "transform.scale"
    animation.values = [0, 1.0, 2.5, 1.0]
    animation.duration = 2.5
    animation.keyTimes = [0, 1.5, 2, 2.5]
    animation.timingFunctions = [
      CAMediaTimingFunction(name: .linear),
      CAMediaTimingFunction(name: .easeOut),
    ]
    return animation
  }
}

// MARK: - Utilities
extension ViewController {
}
