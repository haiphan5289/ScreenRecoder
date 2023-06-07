//
//  ViewController.swift
//  screenchan01
//
//  Created by haiphan on 28/05/2023.
//

import UIKit
import ReplayKit

class ScreenRecorderVC: UIViewController {
    
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecord(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
        setupBroadCastView()
        
        valueObserver = userDefaultBroadcast?.observe(\.broadcast, options: [.initial, .new], changeHandler: { userDefaults, valueChange in
            print("===== valueObserver \(valueChange.newValue)")
            if let value = valueChange.newValue {
                print()
                if value == 1 {
                    
                } else {
                    self.read()
                }
            }
        })

    }
    
    @IBAction func action(_ sender: Any) {
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        read()
        
        observations.append(
            notificationCenter.addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil,
                queue: nil
            ) { [weak self] _ in
                self?.read()
            }
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        observations.forEach(notificationCenter.removeObserver(_:))
    }
    
    private func setupBroadCastView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecord(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func didTapRecord(_ tap: UIGestureRecognizer) {
        if let button = self.broadcastPickerView.subviews.first as? UIButton {
            button.sendActions(for: .touchUpInside)
        }
    }
    
    private func setupRecord() {
        self.view.addSubview(self.broadcastPickerView)
        NSLayoutConstraint.activate([
            self.broadcastPickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.broadcastPickerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.broadcastPickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.broadcastPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    
    private func read() {
        let fileManager = FileManager.default
        var mediaURLs: [URL] = []
        if let container = fileManager
            .containerURL(
                forSecurityApplicationGroupIdentifier: ConstantApp.appGroupName
            )?.appendingPathComponent("\(ConstantApp.FolderName.folderBroadcast)/") {

            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: container.path)
                for path in contents {
                    guard !path.hasSuffix(".plist") else {
                        print("file at path \(path) is plist, exiting")
                        return
                    }
                    let fileURL = container.appendingPathComponent(path)
                    var isDirectory: ObjCBool = false
                    guard fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) else {
                        return
                    }
                    guard !isDirectory.boolValue else {
                        return
                    }
                    let destinationURL = documentsDirectory.appendingPathComponent("\(ConstantApp.FolderName.folderRecordFinish)/" + path)
                    do {
                        try fileManager.copyItem(at: fileURL, to: destinationURL)
                        print("Successfully copied \(fileURL)", "to: ", destinationURL)
                    } catch {
                        print("error copying \(fileURL) to \(destinationURL)", error)
                    }
                    mediaURLs.append(destinationURL)
                }
            } catch {
                print("contents, \(error)")
            }
        }
        
//        mediaURLs.first.map {
//            let asset: AVURLAsset = .init(url: $0)
//            let item: AVPlayerItem = .init(asset: asset)
//
//            let movie: AVMutableMovie = .init(url: $0)
//            for track in movie.tracks {
//                print("track", track)
//            }
//
//            let player: AVPlayer = .init(playerItem: item)
//            let playerViewController: AVPlayerViewController = .init()
//            playerViewController.player = player
//            present(playerViewController, animated: true, completion: { [player = playerViewController.player] in
//                player?.play()
//            })
//        }
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
        return integer(forKey: "broadcast")
    }
    @objc dynamic var stream: Int {
        return integer(forKey: "stream")
    }
}
