//
//  TrimVideoView.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 12/09/2023.
//

import UIKit
import EasyBaseAudio
import RxCocoa
import RxSwift
import SVProgressHUD

class TrimVideoView: UIView {
    
    var updateInputVideo: ((URL) -> Void)?
    var outputVideo: ((URL) -> Void)?
    
    @IBOutlet weak var videoRanger: ABVideoRangeSlider!
    @IBOutlet weak var saveButton: UIButton!
    private var trimVideoTrigger: PublishSubject<RangeTimeSlider> = PublishSubject.init()
    private var trimURL: URL?
    private var outputURL: URL?
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        videoRanger.delegate = self
        setupRX()
    }
    
}
extension TrimVideoView {
    
    private func setupRX() {
        trimVideoTrigger
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, ranger in
                guard let trimURL = owner.trimURL else {
                    return
                }
                SVProgressHUD.show()
                AudioManage.shared.cropVideo(sourceURL: trimURL,
                                             rangeTimeSlider: ranger,
                                             folderName: ConstantApp.FolderName.editVideo.rawValue) { [weak self] outputURL in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.outputURL = outputURL
                        self.updateInputVideo?(outputURL)
                        SVProgressHUD.dismiss()
                    }
                } failure: { _ in
                    SVProgressHUD.dismiss()
                }

            }.disposed(by: disposeBag)
        
        saveButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let url = owner.outputURL else {
                    return
                }
                owner.outputVideo?(url)
            }.disposed(by: disposeBag)
    }
    
    func updateURLVideo(url: URL) {
        self.videoRanger.setVideoURL(videoURL: url,
                                     colorShow: Asset._177Cef.color,
                                     colorDisappear: UIColor.gray)
        videoRanger.updateBgColor(colorBg: UIColor.blue)
        videoRanger.hideTimeLine(hide: true)
        videoRanger.waveForm.isHidden = true
        videoRanger.updateThumbnails()
        trimURL = url
    }
    
}

extension TrimVideoView: ABVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: EasyBaseAudio.ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        let videoRange = RangeTimeSlider(start: startTime, end: endTime)
        self.trimVideoTrigger.onNext(videoRange)
    }
    
    func indicatorDidChangePosition(videoRangeSlider: EasyBaseAudio.ABVideoRangeSlider, position: Float64) {
        
    }
    
    func updateFrameSlide(videoRangeSlider: EasyBaseAudio.ABVideoRangeSlider, startIndicator: CGFloat, endIndicator: CGFloat) {
        
    }
    
    
}
