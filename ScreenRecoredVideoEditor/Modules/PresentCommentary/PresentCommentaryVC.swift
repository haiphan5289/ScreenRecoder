
//
//  
//  PresentCommentaryVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 20/10/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio
import EasyBaseCodes
import SVProgressHUD

class PresentCommentaryVC: UIViewController {
    
    var didSelectVideo: ((URL) -> Void)?
    // Add here outlets
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var myRecordingButton: UIButton!
    @IBOutlet weak var containerDataView: UIView!
    
    // Add here your view model
    private var viewModel: PresentCommentaryVM = PresentCommentaryVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension PresentCommentaryVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        containerDataView.clipsToBounds = true
        containerDataView.layer.cornerRadius = 12
        containerDataView.layer.setCornerRadius(corner: .verticalTop, radius: 12)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        cameraButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.mediaTypes = ["public.movie"]
                vc.delegate = self
                owner.present(vc, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
}
extension PresentCommentaryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            SVProgressHUD.show()
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            AudioManage.shared.converVideofromPhotoLibraryToMP4(videoURL: videoURL, folderName: ConstantApp.FolderName.editVideo.rawValue) { [weak self] outputURL in
                guard let wSelf = self else { return }
                DispatchQueue.main.async {
                    picker.dismiss(animated: true) {
                        SVProgressHUD.dismiss()
                        wSelf.didSelectVideo?(outputURL)
                    }
                }
            }
        }
    }
}
