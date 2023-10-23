
//
//  
//  CommentaryVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 20/10/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import EasyBaseAudio
import SVProgressHUD

class CommentaryVC: BaseVC {
    
    // Add here outlets
    @IBOutlet weak var contentVideo: UIView!
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    var inputURL: URL?
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var handleStackView: UIStackView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    private let trimView: TrimVideoView = .loadXib()
    private let videoPlayView: VideoPlayView = .loadXib()
    // Add here your view model
    private var viewModel: CommentaryVM = CommentaryVM()
    private var recording: Recording = Recording(folderName: "\(ConstantApp.FolderName.editVideo.rawValue)")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Audio Commentary"
        customLeftBarButtonVer2(imgArrow: Asset.icArrowLeft.image)
        setupNavigationBariOS15(font: UIFont.boldSystemFont(ofSize: 18),
                                bgColor: .clear,
                                textColor: UIColor.black)
        navigationController?.hideHairline()
    }
    
}
extension CommentaryVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        timeSlider.value = 0
        timeSlider.minimumValue = 0
        contentVideo.addSubview(videoPlayView)
        videoPlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        videoPlayView.timeProcessHandler = { [weak self] time in
            guard let self = self else { return }
            self.timeLabel.text = Int(time).getTextFromSecond()
            self.timeSlider.value = Float(time)
        }
        videoPlayView.getDuration = { [weak self] time in
            guard let self = self else { return }
            self.timeSlider.maximumValue = Float(time)
        }

        rangeView.addSubview(trimView)
        trimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        trimView.hiddenHeaderStackView(isHidden: true)
        actionView.isHidden = true
        
        DispatchQueue.main.async {
            if let url = self.inputURL {
                self.videoPlayView.playURL(url: url)
                self.trimView.updateURLVideo(url: url)
                
                self.recording.delegate = self
                do {
                    try self.recording.prepare()
                } catch {

                }
                
            }
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        timeSlider.rx.controlEvent(.valueChanged)
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { owner, _ in
                print(" time slider \(owner.timeSlider.value)")
                owner.videoPlayView.handleEndPlayer()
                owner.videoPlayView.playToTime(value: owner.timeSlider.value)
            }.disposed(by: disposeBag)
        
        recordButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                if owner.recordButton.isSelected {
                    owner.handleStackView.isHidden = true
                    owner.recordButton.isHidden = true
                    owner.actionView.isHidden = false
                    owner.stopRecording()
                    SVProgressHUD.show()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        SVProgressHUD.dismiss()
                        owner.videoPlayView.playURL(url: owner.recording.url)
                        owner.trimView.updateURLVideo(url: owner.recording.url)
                    }
                } else {
                    owner.startRecording()
                    owner.recordButton.setTitle("Stop Recording", for: .normal)
                    owner.recordButton.backgroundColor = Asset.ff4039.color
                    owner.recordButton.isSelected = true
                }
            }.disposed(by: disposeBag)
        
        shareButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                ManageApp.shared.shareProductId(sharedObjects: [owner.recording.url])
            }.disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func startRecording() {
        do {
            try self.recording.record()
        } catch {
        }
    }
    
    private func stopRecording() {
        print("======= Recording \(self.recording.url)")
        self.recording.stop()
    }
    
}
extension CommentaryVC: RecorderDelegate {
    func audioMeterDidUpdate(_ dB: Float) {
//        self.dbMeter.onNext(dB)
    }
}
