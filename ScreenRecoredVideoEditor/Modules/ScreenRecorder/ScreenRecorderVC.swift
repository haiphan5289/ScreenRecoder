//
//  ViewController.swift
//  screenchan01
//
//  Created by haiphan on 28/05/2023.
//

import UIKit
import ReplayKit
import EasyBaseAudio

class ScreenRecorderVC: UIViewController {
    
    @IBOutlet weak var imgBroadCast: UIImageView!
    lazy var broadcastPickerView: RPSystemBroadcastPickerView = {
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
    
    var observations: [NSObjectProtocol] = []
    private lazy var notificationCenter: NotificationCenter = .default
    
    static let kBroadcastExtensionBundleId = "haiphan.ScreenRecoredVideoEditor.BroadCast"
    static let kBroadcastExtensionSetupUiBundleId = "haiphan.screenchan03.broadcastSetupUI"
    
    let userDefaultBroadcast = UserDefaults(suiteName: ConstantApp.appGroupName)
    var valueObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        read()
//
//        observations.append(
//            notificationCenter.addObserver(
//                forName: UIApplication.willEnterForegroundNotification,
//                object: nil,
//                queue: nil
//            ) { [weak self] _ in
//                self?.read()
//            }
//        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        observations.forEach(notificationCenter.removeObserver(_:))
    }
    
    
    
}

extension ScreenRecorderVC {
    
    private func setupUI() {
        setupBroadCastView()
        setupRecord()
    }
    
    private func setupRX() {
        valueObserver = userDefaultBroadcast?.observe(\.broadcast,
                                                       options: [.initial, .new],
                                                       changeHandler: { [weak self] userDefaults, valueChange in
            guard let self = self, let value = valueChange.newValue else { return }
            if value == ConstantApp.UserDefaultType.startRecord.value  {
                
            } else {
                self.read()
            }
        })
    }
    
    private func setupBroadCastView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecord(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        self.imgBroadCast.addGestureRecognizer(gesture)
    }
    
    @objc func didTapRecord(_ tap: UIGestureRecognizer) {
        if let button = self.broadcastPickerView.subviews.first as? UIButton {
            button.sendActions(for: .touchUpInside)
        }
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
