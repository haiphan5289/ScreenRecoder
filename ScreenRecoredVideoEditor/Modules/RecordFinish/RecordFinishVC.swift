
//
//  
//  RecordFinishVC.swift
//  ScreenRecoder
//
//  Created by haiphan on 21/05/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes
import AVFoundation

class RecordFinishVC: BaseVC, PlayVideoProtocel {
    
    var inputURL: URL?
    // Add here outlets
    @IBOutlet weak var sectionContentView: UIView!
    @IBOutlet weak var videoEditorContent: UIView!
    @IBOutlet weak var videoEditorButton: UIButton!
    @IBOutlet weak var contentVideo: UIView!
    private let videoEditorView: VideoEditorView = .loadXib()
    // Add here your view model
    private var viewModel: RecordFinishVM = RecordFinishVM()
    private let videoPlayView: VideoPlayView = .loadXib()
    private var playVideo: AVPlayer = AVPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = ""
        customLeftBarButtonVer2(imgArrow: Asset.icArrowLeft.image)
        setupNavigationBariOS15(font: UIFont.boldSystemFont(ofSize: 18),
                                bgColor: .clear,
                                textColor: UIColor.black)
        customRightButton(imgArrow: Asset.icTrash.image)
        navigationController?.hideHairline()
    }
    
}
extension RecordFinishVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        navigationType = .show
        videoEditorContent.addSubview(videoEditorView)
        videoEditorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentVideo.addSubview(videoPlayView)
        videoPlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let url = inputURL {
            videoPlayView.setBgImage(url: url)
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        videoEditorButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.sectionContentView.isHidden = true
                owner.videoEditorContent.isHidden = false
            }.disposed(by: disposeBag)
    }
}
