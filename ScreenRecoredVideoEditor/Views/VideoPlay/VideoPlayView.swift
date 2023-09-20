//
//  VideoPlayView.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 07/06/2023.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class VideoPlayView: UIView, PlayVideoProtocel {
    
    enum VideoPlayViewType {
        case bg, videoplay
    }
    
    var didFinishAVPlayerHandler: (() -> Void)?
    var timeProcessHandler: ((Double) -> Void)?
    
    @IBOutlet weak var bgVideoImage: UIImageView!
    @IBOutlet weak var bgContentView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bgPlayButton: UIImageView!
    
    private var playVideo: AVPlayer = AVPlayer()
    private var url: URL?
    
    private let disposeBag = DisposeBag()
    private let videoPlayType: BehaviorRelay<VideoPlayViewType> = BehaviorRelay(value: .bg)
    private var avplayerManager: AVPlayerManager = AVPlayerManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
    
}
extension VideoPlayView {
    
    private func setupUI() {
        avplayerManager.delegate = self
        let tapGestureView: UITapGestureRecognizer = UITapGestureRecognizer()
        self.videoView.addGestureRecognizer(tapGestureView)
        tapGestureView.rx.event
            .withUnretained(self)
            .bind { owner, _ in
                
                if owner.avplayerManager.isVideoPlaying() {
                    owner.avplayerManager.doAVPlayer(action: .pause)
                    owner.bgVideoImage.isHidden = false
                } else {
                    owner.avplayerManager.doAVPlayer(action: .play)
                    owner.bgVideoImage.isHidden = true
                }
                
            }.disposed(by: disposeBag)
    }
    
    private func setupRX() {
        
//        playButton.rx.tap
//            .withUnretained(self)
//            .bind { owner, _ in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    owner.play(playVideo: owner.playVideo)
//                }
//            }.disposed(by: disposeBag)
    }
    
    func playURL(url: URL) {
        pauseVideo()
        layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.avplayerManager.loadVideoURL(videoURL: url, videoView: self.videoView)
            self.avplayerManager.doAVPlayer(action: .play)
        }
    }
    
    func pauseVideo() {
        self.avplayerManager.doAVPlayer(action: .pause)
        self.bgVideoImage.isHidden = true
    }
    
    func playVideoSelect() {
//        self.play(playVideo: self.playVideo)
    }
    
//    func setBgImage(url: URL) {
//        self.url = url
////        bgVideoImage.image = url.getThumbnailImage()
////        videoPlayType.accept(.bg)
//        guard let url = self.url else {
//            return
//        }
//        layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.videoPlayType.accept(.videoplay)
//            self.playVideo(url: url,
//                            videoView: self.videoView,
//                            playVideo: &self.playVideo)
//            self.play(playVideo: self.playVideo)
//        }
//    }
    
}
extension VideoPlayView: AVPlayerManagerDelegate {
    func getRate(rate: Float) {
        self.bgPlayButton.isHidden = rate == 1
    }
    
    func didFinishAVPlayer() {
        self.bgPlayButton.isHidden = false
        self.didFinishAVPlayerHandler?()
    }
    
    func timeProcess(time: Double) {
        self.timeProcessHandler?(time)
    }
    
    func getDuration(value: Double) {
        
    }
}
