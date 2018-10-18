//
//  AudioRecorder.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/18.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import AVFoundation

protocol AudioRecorderDelegate: class {
  
}

class AudioRecorder: NSObject {
  
  private(set) var recorder: AVAudioRecorder!
  
  private let audioSession = AVAudioSession.sharedInstance()
  
  weak var delegate: AudioRecorderDelegate?
  
  var isRecording: Bool {
    get { return recorder.isRecording }
  }
  
  var isMeteringEnabled: Bool {
    get { return recorder.isMeteringEnabled }
    set { recorder.isMeteringEnabled = newValue }
  }
  
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
  
  func startRecording() throws {
    let url = audioURL(for: temporaryAudioFilename)
    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVEncoderBitRateKey: 32000,
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    recorder = try AVAudioRecorder(url: url, settings: settings)
    recorder.delegate = self
    recorder.isMeteringEnabled = true
    recorder.updateMeters()
    recorder.record()
    
    let displaylink = CADisplayLink(target: self, selector: #selector(step))
    displaylink.preferredFramesPerSecond = 10
    displaylink.add(to: .current, forMode: RunLoop.Mode.common)
  }
  
  func stopRecoding() {
    recorder.stop()
  }
  
  func deleteRecording() {
    recorder.deleteRecording()
  }
}

extension AudioRecorder {
  
  @objc func step(displaylink: CADisplayLink) {
    // do something
    
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

// MARK: Session Event Handlers
extension AudioRecorder {
  
  @objc func handleInterruption(_ notification: NSNotification) {
    if let info = notification.userInfo {
      let type = AVAudioSession.InterruptionType(rawValue: info[AVAudioSessionInterruptionTypeKey] as! UInt)
      if type == .began {
        // interrupt
      }
      else {
        let options = AVAudioSession.InterruptionOptions(rawValue: info[AVAudioSessionInterruptionOptionKey] as! UInt)
        if options == .shouldResume {
          // resume
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
