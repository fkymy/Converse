//
//  ViewController.swift
//  ConverseCloneDemo
//
//  Created by Yuske Fukuyama on 2018/10/10.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  
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
  
  var player = AVPlayer()
  
  var index = 3
  
  @IBAction func onPlay(_ sender: Any) {
    
    let storage = Storage.storage()
    let channelRef = storage.reference().child("channels").child(channelId)

    let localURL = audioURL(for: messageFilenames[0])
    let playerItem = AVPlayerItem(url: localURL)
    self.player = AVPlayer(playerItem: playerItem)
    self.player.play()

//    channelRef.child(messageFilenames[0]).downloadURL { (url, error) in
//      if error != nil {
//        print("error occurred")
//      }
//      else {
//        if let url = url {
//          guard let url = URL(string: url.absoluteString) else {
//            print("url could not be created from string")
//            return
//          }
//
//          print(url.absoluteString)
//          let playerItem = AVPlayerItem(url: url)
//          self.player = AVPlayer(playerItem: playerItem)
//          self.player?.play()
//        }
//      }
//    }
  }
  
  @IBAction func onPrevious(_ sender: Any) {
    
    // if last, play that index
    // if not play the previous index
    // if index is 0, play 0
    if index == (messageFilenames.count - 1) {
      let localURL = audioURL(for: messageFilenames[index])
      let playerItem = AVPlayerItem(url: localURL)
      player.replaceCurrentItem(with: playerItem)
      index -= 1
    }
    else if index == 0 {
      let localURL = audioURL(for: messageFilenames[0])
      let playerItem = AVPlayerItem(url: localURL)
      player.replaceCurrentItem(with: playerItem)
    }
    else {
      let localURL = audioURL(for: messageFilenames[index])
      let playerItem = AVPlayerItem(url: localURL)
      player.replaceCurrentItem(with: playerItem)
      index -= 1
    }
    
    label.text = String(index)
    print(String(describing: player.currentItem))
  }
  
  @IBAction func onNext(_ sender: Any) {
    // play next index
    // if last, stop play
    if index == (messageFilenames.count - 1) {
      player.replaceCurrentItem(with: nil)
      // player.pause()
    }
    else {
      let localURL = audioURL(for: messageFilenames[index])
      let playerItem = AVPlayerItem(url: localURL)
      player.replaceCurrentItem(with: playerItem)
      index += 1
    }
    
    label.text = String(index)
    print(String(describing: player.currentItem))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = String(index)
    print(String(describing: player.currentItem))
    for filename in messageFilenames {
      let audioRef = Storage.storage().reference().child("channels").child(channelId).child(filename)
      let localURL = audioURL(for: filename)
      
      audioRef.getData(maxSize: 1*1024*1024) { (data, error) in
        if let error = error {
          print(error)
          return
        }
        guard let data = data else {
          print("no data")
          return
        }
        do {
          try data.write(to: localURL)
          print("data written for \(filename)")
        }
        catch let error {
          print(error)
        }
      }
    }
    
    player.play()
  }
  
  func audioURL(for filename: String) -> URL {
    return cacheDirectoryURL.appendingPathComponent(filename)
  }
  
  private var cacheDirectoryURL: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
}

