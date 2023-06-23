
//
//  
//  FaceCamVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 08/06/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class FaceCamVC: UIViewController {
    
    var inoutURL: URL?
    
    @IBOutlet weak var facecamView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoSlidder: UISlider!
    private let playVideoView: VideoPlayView = .loadXib()
    // Add here your view model
    private var setupCamera: SetupCameraManage = SetupCameraManage()
    
    private var viewModel: FaceCamVM = FaceCamVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension FaceCamVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        videoSlidder.minimumValue = 0
        videoView.addSubview(playVideoView)
        playVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        guard let url = inoutURL else {
            return
        }
        playVideoView.playURL(url: url)
        videoSlidder.maximumValue = Float(url.getDuration())
        playVideoView.timeProcessHandler = { [weak self] value in
            guard let self = self else { return }
            self.videoSlidder.value = Float(value)
        }
        
        setupCamera.setupFailure = {
            print()
        }
        setupCamera.setupCameraSuccess = {
            print()
        }
        setupCamera.openCamera(frame: CGRect(x: 0, y: 0, width: 100, height: 100), parentView: self.view)
        
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
