//
//  ViewController.swift
//  screenchan01
//
//  Created by haiphan on 28/05/2023.
//

import UIKit
import ReplayKit
import EasyBaseAudio
import RxSwift
import RxCocoa

class ScreenRecorderVC: BaseVC {
    
    @IBOutlet weak var imgBroadCast: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    private var broadcastPickerView: RPSystemBroadcastPickerView = {
        let view = RPSystemBroadcastPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredExtension = ViewController.kBroadcastExtensionBundleId
        view.backgroundColor = .clear
        
        if let button = view.subviews.first as? UIButton {
            button.fillSuperView()
            button.setImage(nil, for: .normal)
            button.setImage(nil, for: .selected)
        }
        
        return view
    }()
    static let kBroadcastExtensionBundleId = "haiphan.ScreenRecoredVideoEditor.BroadCast"
    static let kBroadcastExtensionSetupUiBundleId = "haiphan.screenchan03.broadcastSetupUI"
    
    private let userDefaultBroadcast = UserDefaults(suiteName: ConstantApp.appGroupName)
    private var valueObserver: NSKeyValueObservation?
    private var autoTimeScreen: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Screen Recorder"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopAutoTimer()
        ManageApp.shared.launchApp()
    }
}

extension ScreenRecorderVC {
    
    private func setupUI() {
        navigationType = .show
        setupBackButton()
        setupBroadCastView()
        setupRecord()
    }
    
    private func setupRX() {
        buttonLeft.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        valueObserver = userDefaultBroadcast?.observe(\.broadcast,
                                                       options: [.initial, .new],
                                                       changeHandler: { [weak self] userDefaults, valueChange in
            guard let self = self, let value = valueChange.newValue else { return }
            print(" valueChange.newValue \(valueChange.newValue)")
            if value == ConstantApp.UserDefaultType.startRecord.value  {
                self.setupAutoTimeScreen()
            } else {
                self.stopAutoTimer()
                self.read()
            }
        })
    }
    
    private func setupAutoTimeScreen() {
        autoTimeScreen = nil
        autoTimeScreen = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                print("value \(value)")
            })
    }
    
    private func stopAutoTimer() {
        autoTimeScreen = nil
        autoTimeScreen?.disposed(by: self.disposeBag)
    }
    
    private func setupBroadCastView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecord(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        self.imgBroadCast.addGestureRecognizer(gesture)
    }
    
    @objc func didTapRecord(_ tap: UIGestureRecognizer) {
//        if let button = self.broadcastPickerView.subviews.first as? UIButton {
//            button.sendActions(for: .touchUpInside)
//        }
    }
    
    
    private func setupRecord() {
        self.view.addSubview(self.broadcastPickerView)
        NSLayoutConstraint.activate([
            self.broadcastPickerView.leadingAnchor.constraint(equalTo: self.imgBroadCast.leadingAnchor),
            self.broadcastPickerView.topAnchor.constraint(equalTo: self.imgBroadCast.topAnchor),
            self.broadcastPickerView.trailingAnchor.constraint(equalTo: self.imgBroadCast.trailingAnchor),
            self.broadcastPickerView.bottomAnchor.constraint(equalTo: self.imgBroadCast.bottomAnchor)
        ])
    }
    
    private func read() {
        AudioManage.shared.read(appGroupName: ConstantApp.appGroupName,
                                             folder: ConstantApp.FolderName.folderBroadcast.rawValue,
                                folderFinish: ConstantApp.FolderName.folderRecordFinish.rawValue) { outputURL in
            print(outputURL)
            let vc = RecordFinishVC.createVC()
            vc.inputURL = outputURL
            self.navigationController?.pushViewController(vc)
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(title: nil, message: error)
        }

    }
}


extension UIView {
    
    func fillSuperView() {
        guard let superview = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
extension UserDefaults {
    @objc dynamic var broadcast: Int {
        return integer(forKey: ConstantApp.UserDefaultType.startRecord.key)
    }
    @objc dynamic var stream: Int {
        return integer(forKey: "stream")
    }
}
