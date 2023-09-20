
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

protocol EditorVideoDelegate: AnyObject {
    func updateOutputVideo(video: URL)
}

class EditorVideoVC: BaseVC, PlayVideoProtocel {
    
    enum EditorVideoType {
        case trim
    }
    
    //delegate
    var inputVideo: URL?
    var editorVideoType : EditorVideoType = .trim
    weak var delegate: EditorVideoDelegate?
    
    // Add here outlets
    @IBOutlet weak var contentVideo: UIView!
    @IBOutlet weak var trimContentVideo: UIView!
    private let videoPlayView: VideoPlayView = .loadXib()
    private var playVideo: AVPlayer = AVPlayer()
    private let trimEditorView: TrimVideoView = .loadXib()
    
    // Add here your view model
    private var viewModel: EditorVideoVM = EditorVideoVM()
    
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
                self.navigationController?.popViewController()
                self.delegate?.updateOutputVideo(video: outputVideo)
            }
            
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
