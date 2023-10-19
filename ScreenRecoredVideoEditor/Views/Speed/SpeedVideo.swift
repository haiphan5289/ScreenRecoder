//
//  SpeedVideo.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 19/10/2023.
//

import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio
import SVProgressHUD

class SpeedVideo: UIView {
    
    var changeVideo: ((URL) -> Void)?
    var outputVideo: ((URL) -> Void)?
    
    var videoInput: URL?
    private var currentURL: URL?
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var speedSlider: UISlider!
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
    
}
extension SpeedVideo {
    
    private func setupUI() {
        doneButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let currentURL = owner.currentURL else {
                    return
                }
                owner.outputVideo?(currentURL)
            }.disposed(by: disposeBag)
    }
    
    func setupVideo(url: URL) {
        self.videoInput = url
        self.currentURL = url
    }
    
    private func setupRX() {
        speedSlider.rx.controlEvent(.valueChanged)
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, _ in
                guard let videoInput = owner.videoInput else {
                    return
                }
                SVProgressHUD.show()
                let speed = owner.speedSlider.value
                AudioManage.shared.speedUpVideo(url: videoInput, speed: speed) { [weak self] outputURL in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.currentURL = outputURL
                        self.changeVideo?(outputURL)
                        SVProgressHUD.dismiss()
                    }
                }
                
            }.disposed(by: disposeBag)
    }
    
}
