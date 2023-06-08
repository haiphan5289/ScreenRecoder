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
    
    @IBOutlet weak var bgVideoImage: UIImageView!
    @IBOutlet weak var bgContentView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    private var playVideo: AVPlayer = AVPlayer()
    private var url: URL?
    
    private let disposeBag = DisposeBag()
    private let videoPlayType: BehaviorRelay<VideoPlayViewType> = BehaviorRelay(value: .bg)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRX()
    }
    
}
extension VideoPlayView {
    
    private func setupRX() {
        
        playButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    owner.play(playVideo: owner.playVideo)
                }
            }.disposed(by: disposeBag)

//        videoPlayType
//            .withUnretained(self)
//            .bind { owner, type in
//                switch type {
//                case .bg:
//                    owner.bgContentView.isHidden = false
//                    owner.videoView.isHidden = true
//                case .videoplay:
//                    owner.bgContentView.isHidden = true
//                    owner.videoView.isHidden = false
//                }
//            }.disposed(by: disposeBag)
    }
    
    func playVideoSelect() {
        self.play(playVideo: self.playVideo)
    }
    
    func setBgImage(url: URL) {
        self.url = url
//        bgVideoImage.image = url.getThumbnailImage()
//        videoPlayType.accept(.bg)
        guard let url = self.url else {
            return
        }
        layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.videoPlayType.accept(.videoplay)
            self.playVideo(url: url,
                            videoView: self.videoView,
                            playVideo: &self.playVideo)
            self.play(playVideo: self.playVideo)
        }
    }
    
}
