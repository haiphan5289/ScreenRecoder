//
//  VideoRecordingVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by Hai Phan Thanh on 05/11/2023.
//

import UIKit
import RxSwift
import RxCocoa
import EasyBaseAudio

class VideoRecordingVC: UIViewController, SetupBaseCollection {
    
    enum VideoRecodingType {
        case edit, done
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allVideosButton: UIButton!
    @IBOutlet weak var screenRecording: UIButton!
    @IBOutlet weak var actionContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var icDeletedImage: UIImageView!
    @IBOutlet weak var deletedLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var icShareImage: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var actionView: UIView!
    private let moveView: MoveView = .loadXib()
    private let videoTypeTrigger: BehaviorRelay<VideoRecodingType> = BehaviorRelay(value: .done)
    private let selectTrigger: PublishSubject<Void> = PublishSubject()
    
    private let viewModel = VideoRecordingVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getAllVideo()
    }

}
extension VideoRecordingVC {
    
    private func setupUI() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.allowsMultipleSelection = true
        setupCollectionView(collectionView: collectionView,
                            delegate: self,
                            name: VideoRecordingCell.self)
        
        view.addSubview(moveView)
        DispatchQueue.main.async {
            self.handeMoveView(button: self.allVideosButton)
        }
        
    }
    
    private func setupRX() {
        
        videoTypeTrigger
            .withUnretained(self)
            .bind { owner, type in
                let text = type == .done ? "Edit" : "Done"
                owner.editButton.setTitle(text, for: .normal)
                let title = type == .done ? "My Recordings" : "0 videos Selected"
                owner.titleLabel.text = title
                owner.collectionView.reloadData()
                owner.actionView.isHidden = type == .done
            }.disposed(by: disposeBag)
        
        viewModel.allVideos
            .asDriverOnErrorJustComplete()
            .drive { [weak self] values in
                guard let self = self else {
                    return
                }
                
            }.disposed(by: disposeBag)
        
        viewModel.allVideos
            .bind(to: collectionView.rx
                .items(cellIdentifier: VideoRecordingCell.identifier, cellType: VideoRecordingCell.self)) { [weak self] index, item, cell in
                    guard let self = self else { return }
                    cell.bindModel(url: item)
                    cell.hiddenButton(hidden: self.videoTypeTrigger.value == .done)
                    let list = self.collectionView.indexPathsForSelectedItems ?? []
                    let isExist = list.contains(where: { $0.row == index })
                    cell.selectButton(selected: isExist)
                }
                .disposed(by: self.disposeBag)
        
        self.selectTrigger
            .startWith(())
            .withUnretained(self)
            .bind { owner, _ in
                let count = owner.collectionView.indexPathsForSelectedItems?.count ?? 0
                owner.titleLabel.text = "\(count) videos Selected"
                if count <= 0 {
                    owner.icDeletedImage.image = owner.icDeletedImage.image?.withRenderingMode(.alwaysTemplate)
                    owner.icDeletedImage.tintColor = Asset.c1C1C1.color
                    owner.deletedLabel.textColor = Asset.c1C1C1.color
                    owner.icShareImage.image = owner.icShareImage.image?.withRenderingMode(.alwaysTemplate)
                    owner.icShareImage.tintColor = Asset.c1C1C1.color
                    owner.shareLabel.textColor = Asset.c1C1C1.color
                } else {
                    owner.icDeletedImage.image = Asset.icDeletedVideo.image
                    owner.deletedLabel.textColor = UIColor.black
                    owner.icShareImage.image = Asset.icShare.image
                    owner.shareLabel.textColor = UIColor.black
                }
                owner.deleteButton.isEnabled = count > 0
                owner.shareButton.isEnabled = count > 0
            }.disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected.bind { [weak self] idx in
            guard let self = self,
                  let cell = self.collectionView.cellForItem(at: idx) as? VideoRecordingCell,
                  self.videoTypeTrigger.value == .edit else {
                return
            }
            cell.selectButton(selected: true)
            self.selectTrigger.onNext(())
        }.disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemDeselected.bind { [weak self] idx in
            guard let self = self,
                  let cell = self.collectionView.cellForItem(at: idx) as? VideoRecordingCell,
                  self.videoTypeTrigger.value == .edit else {
                return
            }
            cell.selectButton(selected: false)
            self.selectTrigger.onNext(())
        }.disposed(by: self.disposeBag)
        
        let allVideoTrigger = allVideosButton.rx.tap.map { [weak self] _ -> UIButton? in
            guard let self = self else { return nil }
            self.moveView.setTitle(text: "All Videos")
            return self.allVideosButton
        }
        
        let screenRecording = screenRecording.rx.tap.map { [weak self] _ -> UIButton? in
            guard let self = self else { return nil }
            self.moveView.setTitle(text: "Screen Recordings")
            return self.screenRecording
        }
        Observable.merge(allVideoTrigger, screenRecording)
            .bind { [weak self] button in
                guard let self = self,
                      let button = button else { return }
                self.handeMoveView(button: button)
            }.disposed(by: disposeBag)
        
        editButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let type: VideoRecodingType = owner.videoTypeTrigger.value == .done ? .edit : .done
                owner.videoTypeTrigger.accept(type)
            }.disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let indexs = owner.collectionView.indexPathsForSelectedItems else {
                    return
                }
                indexs.forEach { index in
                    if let url = owner.viewModel.allVideos.value.safe[index.row] {
                        AudioManage.shared.deleteFile(filePath: url)
                    }
                    
                }
                owner.viewModel.getAllVideo()
            }.disposed(by: disposeBag)
        
        shareButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let indexs = owner.collectionView.indexPathsForSelectedItems else {
                    return
                }
                let list = indexs.map({ owner.viewModel.allVideos.value.safe[$0.row] }).compactMap({ $0 })
                ManageApp.shared.shareProductId(sharedObjects: list)
            }.disposed(by: disposeBag)
        
    }
    
    private func handeMoveView(button: UIButton) {
        let frame = actionContainerView.convert(button.frame, to: self.view)
        UIView.animate(withDuration: 0.3) {
            self.moveView.frame = CGRect(x: frame.origin.x + 38,
                                         y: frame.origin.y + 4,
                                         width: frame.width - 16,
                                         height: frame.height - 8)
        }
        print(frame)
    }
    
}
extension VideoRecordingVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.width - 32 - 11) / 2
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
}
