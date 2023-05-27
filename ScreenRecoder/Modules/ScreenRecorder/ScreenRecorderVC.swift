
//
//  
//  ScreenRecorderVC.swift
//  ScreenRecoder
//
//  Created by haiphan on 21/05/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes
import ReplayKit

class ScreenRecorderVC: BaseVC {
    
    @IBOutlet weak var recorderImage: UIImageView!
    
    // Add here your view model
    private var viewModel: ScreenRecorderVM = ScreenRecorderVM()
    
    lazy var broadcastPickerView: RPSystemBroadcastPickerView = {
        let view = RPSystemBroadcastPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredExtension = "com.recordscreen1.Broadcast-LiveStream"
        view.backgroundColor = .clear
        
        if let button = view.subviews.first as? UIButton {
            button.fillSuperView()
            button.setImage(nil, for: .normal)
            button.setImage(nil, for: .selected)
        }
        
        return view
    }()
    
//    let userDefaultBroadcast = UserDefaults(suiteName: "group.com.hpscreenrecorder1")
//    lazy var notifiCenter: NotificationCenter = .default
//    var valueObserver: NSKeyValueObservation?
//    var objProtocol: [NSObjectProtocol] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
        
//        self.setupNavigationView()
        self.setupRecord()
//        valueObserver = userDefaultBroadcast?.observe(\.broadcast, options: [.initial, .new], changeHandler: { userDefaults, valueChange in
//            if let value = valueChange.newValue {
//                if value == 1 {
////                    self.start()
//                } else {
////                    self.stop()
//                }
//            }
//        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Screen Recorder"
        customLeftBarButtonVer2(imgArrow: Asset.icArrowLeft.image)
        setupNavigationBariOS15(font: UIFont.boldSystemFont(ofSize: 18),
                                bgColor: .clear,
                                textColor: UIColor.black)
        navigationController?.hideHairline()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        read()

//        self.objProtocol.append(
//            self.notifiCenter.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: { [weak self] _ in
////                self?.saveFile()
//            })
//        )
    }
    
    private func setupRecord() {
        self.view.addSubview(self.broadcastPickerView)
        NSLayoutConstraint.activate([
            self.broadcastPickerView.leadingAnchor.constraint(equalTo: self.recorderImage.leadingAnchor),
            self.broadcastPickerView.topAnchor.constraint(equalTo: self.recorderImage.topAnchor),
            self.broadcastPickerView.trailingAnchor.constraint(equalTo: self.recorderImage.trailingAnchor),
            self.broadcastPickerView.bottomAnchor.constraint(equalTo: self.recorderImage.bottomAnchor)
        ])
    }
    
}
extension ScreenRecorderVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        navigationType = .show
        
//        self.recorderImage.image = self.state.image
//        self.timeLabel.text = "00:00:00"
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecord(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        self.recorderImage.addGestureRecognizer(gesture)
        
        setupBroadCastView()
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
    
    private func setupBroadCastView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapRecord(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        self.recorderImage.addGestureRecognizer(gesture)
    }
    
    @objc func didTapRecord(_ tap: UIGestureRecognizer) {
        if let button = self.broadcastPickerView.subviews.first as? UIButton {
            button.sendActions(for: .touchUpInside)
        }
    }
    
    private func read() {
        let fileManager = FileManager.default
        var mediaURLs: [URL] = []
        if let container = fileManager
                .containerURL(
                    forSecurityApplicationGroupIdentifier: "group.com.metaic.screenrecorder1"
                )?.appendingPathComponent("Library/Documents/") {

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
                    let destinationURL = documentsDirectory.appendingPathComponent(path)
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
