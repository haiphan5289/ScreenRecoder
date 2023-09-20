
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
import EasyBaseAudio

class RecordFinishVC: BaseVC, PlayVideoProtocel, NavigationProtocol {
    
    var inputURL: URL?
    // Add here outlets
    @IBOutlet weak var sectionContentView: UIView!
    @IBOutlet weak var videoEditorContent: UIView!
    @IBOutlet weak var videoEditorButton: UIButton!
    @IBOutlet weak var contentVideo: UIView!
    private let videoEditorView: VideoEditorView = .loadXib()
    @IBOutlet weak var faceCamButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var trimVideoButton: UIButton!
    @IBOutlet weak var editorVideoView: UIView!
    @IBOutlet weak var mainEditView: UIView!
    @IBOutlet weak var trimEditorContentView: UIView!
    @IBOutlet weak var trimActionButton: UIButton!
    // Add here your view model
    private var viewModel: RecordFinishVM = RecordFinishVM()
    private let videoPlayView: VideoPlayView = .loadXib()
    private var playVideo: AVPlayer = AVPlayer()
    private let trimEditorVIew: TrimVideoView = .loadXib()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayView.pauseVideo()
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
            videoPlayView.playURL(url: url)
        }
        editorVideoView.isHidden = true
        trimEditorContentView.addSubview(trimEditorVIew)
        trimEditorVIew.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        faceCamButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let inputURL = owner.inputURL else {
                    return
                }
                owner.moveToFaceCame(inputURL: inputURL)
            }.disposed(by: disposeBag)
        
        buttonRight.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.showAlert(title: "Confirm Delete",
                                message: "This action can't be undone. Do you want to continue?",
                                buttonTitles: ["Cancel", "Delete"],
                                highlightedButtonIndex: 1) { index in
                    if index == 1 {
                        AudioManage.shared.removeFilesFolder(name: ConstantApp.FolderName.folderRecordFinish.rawValue)
                        ConstantApp.shared.removeFilesFolder()
                        owner.navigationController?.popViewController()
                    }
                }
            }.disposed(by: disposeBag)
        
        videoEditorButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.sectionContentView.isHidden = true
                owner.videoEditorContent.isHidden = false
                owner.mainEditView.isHidden = true
                owner.editorVideoView.isHidden = false
            }.disposed(by: disposeBag)
        
        shareButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if let url = owner.inputURL {
                    ManageApp.shared.shareProductId(sharedObjects: [url])
                }
            }.disposed(by: disposeBag)
        
        trimVideoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if let url = owner.inputURL {
                    owner.moveToEditorVideo(inputURL: url, delegate: owner, editorVideoType: .trim)
                }
            }.disposed(by: disposeBag)
    }
    
    private func handleUpdateInputVideo(video: URL) {
        self.inputURL = video
        videoPlayView.playURL(url: video)
    }
    
}
extension RecordFinishVC: EditorVideoDelegate {
    func updateOutputVideo(video: URL) {
        handleUpdateInputVideo(video: video)
    }
}
