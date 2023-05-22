
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
    
    // Add here outlets
    lazy var broadcastView: RPSystemBroadcastPickerView = {
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
    @IBOutlet weak var recorderImage: UIImageView!
    
    // Add here your view model
    private var viewModel: ScreenRecorderVM = ScreenRecorderVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
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
    
}
extension ScreenRecorderVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        navigationType = .show
        setupBroadCastView()
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
    
    private func setupBroadCastView() {
        self.recorderImage.addSubview(broadcastView)
        broadcastView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
