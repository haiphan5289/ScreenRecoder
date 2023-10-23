//
//  AVPlayerManager.swift
//  EasyAudio
//
//  Created by haiphan on 09/06/2022.
//

import Foundation
import AVFoundation
import UIKit
import RxSwift
import EasyBaseAudio

protocol AVPlayerManagerDelegate: AnyObject {
    func didFinishAVPlayer()
    func timeProcess(time: Double)
    func getDuration(value: Double)
    func getRate(rate: Float)
}

final class AVPlayerManager {
    
    enum Action {
        case play, pause, mute, rewind(Float64), forward(Float64)
    }
    
    var videoURL: URL?
    var player: AVPlayer?
    weak var delegate: AVPlayerManagerDelegate?
    private var autoRunAudio: Disposable?
    public init() {
        self.setup()
    }
    
    deinit {
        self.disAudoRun()
        self.doAVPlayer(action: .pause)
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerEndedPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    @objc func playerEndedPlaying(_ notification: Notification) {
       DispatchQueue.main.async {[weak self] in
           guard let wSelf = self else { return }
           wSelf.player?.seek(to: .zero)
           wSelf.doAVPlayer(action: .pause)
           wSelf.delegate?.didFinishAVPlayer()
           wSelf.disAudoRun()
       }
    }
    
    func isVideoPlaying() -> Bool {
        return self.player?.rate == 1
    }
    
    func doAVPlayer(action: Action) {
        guard let player = self.player else {
            return
        }
        switch action {
        case .play: player.play()
        case .pause: player.pause()
        case .mute: player.isMuted = true
        case .forward(let value): self.forwardVideo(by: value)
        case .rewind(let value): self.rewindVideo(by: value)
        }
    }
    
    func handeEndPlayer() {
        guard let player = self.player else {
            return
        }
        self.player?.seek(to: .zero)
        self.doAVPlayer(action: .pause)
        self.delegate?.didFinishAVPlayer()
        self.disAudoRun()
        self.delegate?.timeProcess(time: 0)
        self.delegate?.getRate(rate: player.rate)
    }
    
    
    func playToTime(value: Float) {
        DispatchQueue.main.async {[weak self] in
            guard let wSelf = self else { return }
            wSelf.player?.seek(to: CMTime(value: CMTimeValue(value * 1000), timescale: 1000))
            wSelf.player?.play()
            wSelf.autoRun()
        }
    }
    
    func rewindVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }

    func forwardVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    func getDuration() -> Double {
        guard let videoURL = videoURL else {
            return 0
        }
        return videoURL.getDuration()
    }
    
    func loadVideoURL(videoURL: URL, videoView: UIView, frame: CanvasView.CanasViewType = .noFrame) {
        do {
            videoView.subviews.forEach { view in
                view.removeFromSuperview()
            }
            videoView.layer.sublayers?.forEach({ layer in
                layer.removeFromSuperlayer()
            })
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            self.videoURL = videoURL
            let asset = AVAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: playerItem)
            
            //3. Create AVPlayerLayer object
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = videoView.bounds//bounds of the view in which AVPlayer should be displayed
            
            switch frame {
            case .noFrame: break
            case .oneone:
                let width = videoView.bounds.size.width
                playerLayer.frame.size = CGSize(width: width, height: width)
            case .fourfive:
                let width = videoView.bounds.size.width
                let height = width * (5/4)
                playerLayer.frame.size = CGSize(width: width, height: height)
            case .sixteennine:
                let width = videoView.bounds.size.width
                var height = width * (16/9)
                
                if height >= videoView.bounds.size.height {
                    height = videoView.bounds.size.height
                }
                
                playerLayer.frame.size = CGSize(width: width, height: height)
            case .ninesixteeen:
                let width = videoView.bounds.size.width
                var height = width * (9/16)
                
                if height >= videoView.bounds.size.height {
                    height = videoView.bounds.size.height
                }
                
                playerLayer.frame.size = CGSize(width: width, height: height)
            }
            
            playerLayer.videoGravity = .resizeAspect
            playerLayer.player?.volume = 1
            
//            var scaleX: CGFloat = 1
//            var scaleY: CGFloat = 1
//            
//            let sizeVideo = videoURL.getVideoResolution() ?? .zero
//            
//            let ratio = sizeVideo.width / sizeVideo.height
//            
//            if ratio < 1 && sizeVideo.width > videoView.frame.width {
//                scaleX = videoView.frame.width / sizeVideo.width
//            }
//            
//            if ratio > 1 && sizeVideo.height > videoView.frame.height {
//                scaleY = videoView.frame.height / sizeVideo.height
//            }
//            
//            
//            let transform = CGAffineTransform.init(scaleX: scaleX, y: scaleY)
//            playerLayer.setAffineTransform(transform)
//            playerLayer.videoGravity = AVLayerVideoGravity.resize
            videoView.layoutIfNeeded()
            playerLayer.layoutIfNeeded()
            
            //4. Add playerLayer to view's layer
            videoView.layer.addSublayer(playerLayer)
            self.delegate?.getDuration(value: videoURL.getDuration())
            
            guard let player = player else {
                return
            }
            self.autoRun()
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
//        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2),
//                                       queue: DispatchQueue.main) {[weak self] (progressTime) in
//            guard let wSelf = self else { return }
//            wSelf.delegate?.timeProcess(time: CMTimeGetSeconds(progressTime))
////            if let duration = player.currentItem?.duration {
////                let durationSeconds = CMTimeGetSeconds(duration)
////                wSelf.progress = CMTimeGetSeconds(progressTime)
////                percent = Float(seconds/durationSeconds)
////                print("====== \(wSelf.progress)")
////                DispatchQueue.main.async {
////                    if (wSelf.progress ?? 0) >= 1.0 {
////                        wSelf.progress = 0.0
////                    }
////                }
////            }
//        }
    }
    
    private func disAudoRun() {
        self.autoRunAudio?.dispose()
    }
    
    private func autoRun() {
        self.autoRunAudio?.dispose()
        self.autoRunAudio = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance).bind(onNext: { [weak self] time in
            guard let wSelf = self, let player = wSelf.player else { return }
            if let currentItem = player.currentItem {
                let duration = CMTimeGetSeconds(currentItem.duration)
                let currentTime = CMTimeGetSeconds(currentItem.currentTime())
                print("Duration: \(duration) s")
                print("Current time: \(currentTime) s")
            }
            print("Rate \(player.rate)")
            
            wSelf.delegate?.timeProcess(time: player.currentItem?.currentTime().seconds ?? 0)
            wSelf.delegate?.getRate(rate: player.rate)
        })
    }
}
