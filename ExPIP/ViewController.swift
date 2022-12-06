//
//  ViewController.swift
//  ExPIP
//
//  Created by 김종권 on 2022/12/05.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
  private let playerLayer = AVPlayerLayer()
  private let player = AVPlayer()
  private var pipController: AVPictureInPictureController?
  private let button: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("pip 활성화", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setPip()
    setupLayout()
  }
  
  private func setPip() {
    guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
    
    let asset = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: asset)
    playerLayer.player = player
    playerLayer.videoGravity = .resizeAspect
    view.layer.addSublayer(playerLayer)
    player.play()
    
    print(123)
    guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
    print(456)
    pipController = AVPictureInPictureController(playerLayer: playerLayer)
    pipController?.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    playerLayer.frame = view.bounds
  }
  
  private func setupLayout() {
    view.addSubview(button)
    
    button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    button.setTitle("활성화", for: .normal)
    
    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
  @objc func tapButton() {
    guard let isActive = pipController?.isPictureInPictureActive else { return }
    isActive ? pipController?.stopPictureInPicture() : pipController?.startPictureInPicture()
    isActive ? button.setTitle("비활성화", for: .normal) : button.setTitle("활성화", for: .normal)
  }
  
}

extension ViewController: AVPictureInPictureControllerDelegate {
  
}
