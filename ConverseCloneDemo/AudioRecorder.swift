//
//  AudioRecorder.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/18.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import AVFoundation

protocol AudioRecorderDelegate: class {
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didStartRecording url: URL)
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didStepMetering at: CFTimeInterval, averagePower: Float, peakPower: Float)
  
  func audioRecorder(_ audioRecorder: AudioRecorder, didFinishRecording url: URL)
}

class AudioRecorder: NSObject {
  
  private(set) var recorder: AVAudioRecorder!
  
  private let session = AVAudioSession.sharedInstance()
  
  weak var delegate: AudioRecorderDelegate?
  
  private var displaylink: CADisplayLink?
  
  var isRecording: Bool {
    get {
      if let recorder = recorder {
        return recorder.isRecording
      }
      return false
    }
  }
  
  var pausedForInterruption = false
  
  override init() {
    super.init()
    let nc = NotificationCenter.default
    nc.addObserver(self,
                   selector: #selector(handleInterruption),
                   name: AVAudioSession.interruptionNotification,
                   object: nil)
    nc.addObserver(self,
                   selector: #selector(handleRouteChange),
                   name: AVAudioSession.routeChangeNotification,
                   object: nil)
  }
  
  deinit {
    stopMetering()
    let nc = NotificationCenter.default
    nc.removeObserver(self,
                      name: AVAudioSession.interruptionNotification,
                      object: nil)
    nc.removeObserver(self,
                      name: AVAudioSession.routeChangeNotification,
                      object: nil)
  }
}

// MARK: - Controls
extension AudioRecorder {
  
  func startRecording() {
    guard !isRecording else {
      return
    }
    
    let url = audioURL(for: temporaryAudioFilename)
    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVEncoderBitRateKey: 32000,
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      try setAudioSession(active: true)
      recorder = try AVAudioRecorder(url: url, settings: settings)
    }
    catch let error {
      print(error)
      return
    }
    
    recorder.delegate = self
    recorder.isMeteringEnabled = true
    recorder.record()
    
    delegate?.audioRecorder(self, didStartRecording: url)
    startMetering()
  }
  
  func stopRecoding() {
    recorder.stop()
    stopMetering()
    delegate?.audioRecorder(self, didFinishRecording: audioURL(for: temporaryAudioFilename))
  }
  
  func pauseRecording() {
    pausedForInterruption = true
    recorder.pause()
  }
  
  func resumeRecording() {
    if pausedForInterruption {
      recorder.record()
    }
    pausedForInterruption = false
  }
  
  func deleteRecording() {
    recorder.deleteRecording()
  }
}

// MARK: - Metering
extension AudioRecorder {
  
  func startMetering() {
    displaylink = CADisplayLink(target: self, selector: #selector(step))
    displaylink?.add(to: .current, forMode: RunLoop.Mode.common)
    displaylink?.preferredFramesPerSecond = 10
  }
  
  func stopMetering() {
    displaylink?.invalidate()
    displaylink = nil
  }
  
  @objc func step(displaylink: CADisplayLink) {
    guard let recorder = recorder else { return }
    recorder.updateMeters()
    let timestamp = displaylink.timestamp
    let correction: Float = 0
    let average = recorder.averagePower(forChannel: 0) + correction
    let peak = recorder.peakPower(forChannel: 0) + correction
    delegate?.audioRecorder(self, didStepMetering: timestamp, averagePower: average, peakPower: peak)
  }
}

extension AudioRecorder: AVAudioRecorderDelegate {

  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag == true {
      
    }
    else {
      
    }
  }
  
  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    // handle error
  }
}

// MARK: - Utility
extension AudioRecorder {
  
  private func generateNewAudioFilename() -> String {
    return [UUID().uuidString, ".m4a"].joined()
  }
  
  private var temporaryAudioFilename: String {
    return "temporary.m4a"
  }
  
  private func audioURL(for filename: String) -> URL {
    return cacheDirectoryURL.appendingPathComponent(filename)
  }
  
  private var cacheDirectoryURL: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
}

// MARK: - AVAudioSession
extension AudioRecorder {
  
  func setAudioSession(active: Bool) throws {
    try session.setCategory(.record, mode: .spokenAudio)
    try session.setActive(true)
  }
  
  @objc func handleInterruption(_ notification: NSNotification) {
    if let info = notification.userInfo {
      let type = AVAudioSession.InterruptionType(rawValue: info[AVAudioSessionInterruptionTypeKey] as! UInt)
      if type == .began {
        pauseRecording()
      }
      else {
        let options = AVAudioSession.InterruptionOptions(rawValue: info[AVAudioSessionInterruptionOptionKey] as! UInt)
        if options == .shouldResume {
          resumeRecording()
        }
      }
    }
  }
  
  @objc func handleRouteChange(_ notification: NSNotification) {
    if let info = notification.userInfo {
      let reason = AVAudioSession.RouteChangeReason(rawValue: info[AVAudioSessionRouteChangeReasonKey] as! UInt)
      if reason == .oldDeviceUnavailable {
        let previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
        let previousOutput = previousRoute!.outputs.first!
        if convertFromAVAudioSessionPort(previousOutput.portType) == convertFromAVAudioSessionPort(AVAudioSession.Port.headphones) {
          // interrupt
        }
      }
    }
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
  return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionPort(_ input: AVAudioSession.Port) -> String {
  return input.rawValue
}
