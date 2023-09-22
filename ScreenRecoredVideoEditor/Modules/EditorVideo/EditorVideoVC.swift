
//
//  
//  EditorVideoVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 20/09/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes
import AVFoundation
import SnapKit
import SVProgressHUD

protocol EditorVideoDelegate: AnyObject {
    func updateOutputVideo(video: URL)
}

class EditorVideoVC: BaseVC, PlayVideoProtocel {
    
    enum EditorVideoType {
        case trim, filter
    }
    
    //delegate
    var inputVideo: URL?
    var editorVideoType : EditorVideoType = .trim
    weak var delegate: EditorVideoDelegate?
    
    // Add here outlets
    @IBOutlet weak var contentVideo: UIView!
    @IBOutlet weak var trimContentVideo: UIView!
    @IBOutlet weak var filterContentView: UIView!
    private let videoPlayView: VideoPlayView = .loadXib()
    private var playVideo: AVPlayer = AVPlayer()
    private let trimEditorView: TrimVideoView = .loadXib()
    private let filterVideoView: FilterVideoView = .loadXib()
    
    // Add here your view model
    private var viewModel: EditorVideoVM = EditorVideoVM()
    private let loadingTrigger: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
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
        navigationController?.hideHairline()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayView.pauseVideo()
    }
    
}
extension EditorVideoVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        navigationType = .show
        contentVideo.addSubview(videoPlayView)
        videoPlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let url = self.inputVideo {
            videoPlayView.playURL(url: url)
        }
        
        
        trimContentVideo.addSubview(trimEditorView)
        trimEditorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        filterContentView.addSubview(filterVideoView)
        filterVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        switch editorVideoType {
        case .trim:
            trimContentVideo.isHidden = false
            if let url = self.inputVideo {
                trimEditorView.updateURLVideo(url: url)
            }
            trimEditorView.updateInputVideo = { [weak self] outputVideo in
                guard let self = self else { return }
                videoPlayView.playURL(url: outputVideo)
            }
            trimEditorView.outputVideo = { [weak self] outputVideo in
                guard let self = self else { return }
                self.handlePopViewController(outputVideo: outputVideo)
            }
        case .filter:
            if let inputVideo = self.inputVideo {
                filterVideoView.setCurrentURL(url: inputVideo)
            }
            filterVideoView.outputVideo = { [weak self] outputURL in
                guard let self = self else { return }
                self.handlePopViewController(outputVideo: outputURL)
                
            }
            filterVideoView.videoFilter = { [weak self] outputURL in
                guard let self = self else { return }
                videoPlayView.playURL(url: outputURL)
            }
            filterVideoView.isProcessing = { [weak self] isLoading in
                guard let self = self else { return }
                self.loadingTrigger.accept(isLoading)
            }
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        loadingTrigger
            .asDriver()
            .drive { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }.disposed(by: disposeBag)
    }
    
    private func handlePopViewController(outputVideo: URL) {
        self.navigationController?.popViewController()
        self.delegate?.updateOutputVideo(video: outputVideo)
    }
}
