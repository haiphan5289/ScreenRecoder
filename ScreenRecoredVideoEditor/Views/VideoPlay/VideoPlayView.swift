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
        layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.avplayerManager.loadVideoURL(videoURL: url, videoView: self.videoView)
            self.avplayerManager.doAVPlayer(action: .play)
            
            let checkView: UIView = UIView(frame: .zero)
            checkView.backgroundColor = .red
            self.addSubview(checkView)
            checkView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.width.equalTo(50)
            }
        }
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
    func didFinishAVPlayer() {
        self.didFinishAVPlayerHandler?()
    }
    
    func timeProcess(time: Double) {
        self.timeProcessHandler?(time)
    }
    
    func getDuration(value: Double) {
        
    }
}
