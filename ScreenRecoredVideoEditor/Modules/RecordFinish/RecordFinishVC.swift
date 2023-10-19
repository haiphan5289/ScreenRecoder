
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
import SVProgressHUD

class RecordFinishVC: BaseVC, PlayVideoProtocel, NavigationProtocol {
    
    enum RotateVideoType {
        case pi, pi2, pi3, pi4
    }
    
    var inputURL: URL?
    var currentURL: URL?
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
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var canvasButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    // Add here your view model
    private var viewModel: RecordFinishVM = RecordFinishVM()
    private let videoPlayView: VideoPlayView = .loadXib()
    private var playVideo: AVPlayer = AVPlayer()
    private let trimEditorVIew: TrimVideoView = .loadXib()
    private let loadingTrigger: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var rotateCurrent: RotateVideoType = .pi
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
        
        filterButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if let url = owner.inputURL {
                    owner.moveToEditorVideo(inputURL: url, delegate: owner, editorVideoType: .filter)
                }
            }.disposed(by: disposeBag)
        
        speedButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if let url = owner.inputURL {
                    owner.moveToEditorVideo(inputURL: url, delegate: owner, editorVideoType: .speed)
                }
            }.disposed(by: disposeBag)
        
        rotateButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let inputVideo = owner.inputURL else {
                    return
                }
                switch owner.rotateCurrent {
                case .pi:
                    owner.rotateVideo(inputVideo: inputVideo, rotate: .pi)
                    owner.rotateCurrent = .pi2
                case .pi2:
                    owner.rotateVideo(inputVideo: inputVideo, rotate: .pi2)
                    owner.rotateCurrent = .pi3
                case .pi3:
                    owner.rotateVideo(inputVideo: inputVideo, rotate: .pi3)
                    owner.rotateCurrent = .pi4
                case .pi4:
                    owner.rotateVideo(inputVideo: inputVideo, rotate: .pi4)
                    owner.rotateCurrent = .pi
                }
            }.disposed(by: disposeBag)
        
        canvasButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if let url = owner.inputURL {
                    owner.moveToEditorVideo(inputURL: url, delegate: owner, editorVideoType: .canvas)
                }
            }.disposed(by: disposeBag)
        
        loadingTrigger
            .asDriver()
            .drive { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }.disposed(by: disposeBag)
    }
    
    private func handleUpdateInputVideo(video: URL) {
        self.inputURL = video
        videoPlayView.playURL(url: video)
    }
    
    func mergeVideoAndAudio(videoUrl: URL, rotate: RotateVideoType) -> AVAsset {

        let mixComposition = AVMutableComposition()
        var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioOfVideoTrack = [AVMutableCompositionTrack]()

        //start merge

        let aVideoAsset = AVAsset(url: videoUrl)

        let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: .video,
                                                                 preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAddAudioOfVideo = mixComposition.addMutableTrack(withMediaType: .audio,
                                                                        preferredTrackID: kCMPersistentTrackID_Invalid)

        let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aAudioOfVideoAssetTrack: AVAssetTrack? = aVideoAsset.tracks(withMediaType: AVMediaType.audio).first

        // Default must have tranformation

        compositionAddVideo?.preferredTransform = aVideoAssetTrack.preferredTransform

        var transforms = aVideoAssetTrack.preferredTransform
        
        switch rotate {
        case .pi:
            transforms = transforms.concatenating(CGAffineTransform(rotationAngle: CGFloat(-90.0 * .pi / 180)))
            transforms = transforms.concatenating(CGAffineTransform(translationX: 1280, y: 0))
        case .pi2:
            transforms = transforms.concatenating(CGAffineTransform(rotationAngle: CGFloat(-180.0 * .pi / 180)))
            transforms = transforms.concatenating(CGAffineTransform(translationX: 0, y: 720))
        case .pi3:
            transforms = transforms.concatenating(CGAffineTransform(rotationAngle: CGFloat(-270.0 * .pi / 180)))
            transforms = transforms.concatenating(CGAffineTransform(translationX: 1280, y: 0))
        case .pi4:
            transforms = transforms.concatenating(CGAffineTransform(rotationAngle: CGFloat(-360.0 * .pi / 180)))
            transforms = transforms.concatenating(CGAffineTransform(translationX: 0, y: 720))

        }

        
        compositionAddVideo?.preferredTransform = transforms


        mutableCompositionVideoTrack.append(compositionAddVideo!)
        mutableCompositionAudioOfVideoTrack.append(compositionAddAudioOfVideo!)

        do {

            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                duration: aVideoAssetTrack.timeRange.duration),
                                                                of: aVideoAssetTrack,
                                                                at: CMTime.zero)

            //In my case my audio file is longer then video file so i took videoAsset duration
            //instead of audioAsset duration

            // adding audio (of the video if exists) asset to the final composition
            if let aAudioOfVideoAssetTrack = aAudioOfVideoAssetTrack {
                try mutableCompositionAudioOfVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                           duration: aVideoAssetTrack.timeRange.duration),
                                                                           of: aAudioOfVideoAssetTrack,
                                                                           at: CMTime.zero)
            }
        } catch {
            print(error.localizedDescription)
        }

        return mixComposition

    }
    
    private func rotateVideo(inputVideo: URL, rotate: RotateVideoType) {
        loadingTrigger.accept(true)
        let asset = self.mergeVideoAndAudio(videoUrl: inputVideo, rotate: rotate)
        if let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080) {
            export.outputFileType = AVFileType.mov
            let outputURL = AudioManage.shared.createURL(folder: ConstantApp.FolderName.filter.rawValue,
                                                         name: AudioManage.shared.parseDatetoString(),
                                                         type: .mp4)
            export.outputURL = outputURL
            //save it into your local directory
            
            //Delete Existing file
            do
                {
                    try FileManager.default.removeItem(at: outputURL)
                }
            catch let error as NSError
            {
                print(error.debugDescription)
            }
            
            export.outputURL = outputURL
            /// try to export the file and handle the status cases
            export.exportAsynchronously(completionHandler: { [weak self] in
                guard let self = self else {
                    self?.loadingTrigger.accept(false)
                    return
                }
                switch export.status {
                case .failed:
                    self.loadingTrigger.accept(false)
                    
                case .cancelled:
                    self.loadingTrigger.accept(false)
                default:
                    print("finished")
                    DispatchQueue.main.async {
                        self.currentURL = outputURL
                        self.loadingTrigger.accept(false)
                        self.videoPlayView.playURL(url: outputURL)
                    }
                }
            })
        } else {
            self.loadingTrigger.accept(false)
        }

    }
}
extension RecordFinishVC: EditorVideoDelegate {
    func updateOutputVideo(video: URL) {
        handleUpdateInputVideo(video: video)
    }
}
