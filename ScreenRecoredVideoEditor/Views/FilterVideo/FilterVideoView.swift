//
//  FilterVideoView.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 21/09/2023.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import EasyBaseAudio

class FilterVideoView: UIView, SetupBaseCollection {
    
    var videoFilter: ((URL) -> Void)?
    var inputVideo: URL? 
    var isProcessing: ((Bool) -> Void)?
    var outputVideo: ((URL) -> Void)?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private var currentURL: URL?
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
}
extension FilterVideoView {
    
    private func setupUI() {
        setupCollectionView(collectionView: collectionView , delegate: self, name: FilterVideoCell.self)
    }
    
    private func setupRX() {
        
        saveButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let inputVideo = owner.currentURL else {
                    return
                }
                owner.outputVideo?(inputVideo)
                owner.removeFromSuperview()
            }.disposed(by: disposeBag)
        
        Observable.just(FilterManager.shared.listFilter())
            .bind(to: self.collectionView.rx.items(cellIdentifier: FilterVideoCell.identifier, cellType: FilterVideoCell.self)) { row, data, cell in
                cell.bgFilter.image = data.image
            }.disposed(by: disposeBag)
        
        self.collectionView
            .rx
            .itemSelected
            .withUnretained(self)
            .bind { owner, idx in
                guard let item = FilterManager.shared.listFilter().safe[idx.row],
                      let inputVideo = owner.inputVideo else {
                    return
                }
                owner.handleInputURL(inputVideo: inputVideo, filter: item.cifilter)
            }.disposed(by: disposeBag)
        
    }
    
    func setCurrentURL(url: URL) {
        self.inputVideo = url
        self.currentURL = url
    }
    
    func handleInputURL(inputVideo: URL, filter: CIFilter) {
        self.isProcessing?(true)
        let asset = AVAsset(url: inputVideo)
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            if let outputImage = filter.outputImage {
                let output = outputImage.cropped(to: request.sourceImage.extent)
                request.finish(with: output, context: nil)
            } else {
                request.finish(with: request.sourceImage, context: nil)
            }
        })
        if let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080) {
            export.outputFileType = AVFileType.mov
            let outputURL = AudioManage.shared.createURL(folder: ConstantApp.FolderName.filter.rawValue,
                                                         name: AudioManage.shared.parseDatetoString(),
                                                         type: .mp4)
            export.outputURL = outputURL
            export.videoComposition = composition
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
                    self?.isProcessing?(false)
                    return
                }
                switch export.status {
                case .failed:
                    if let _error = export.error {
//                            failure(_error)
                    }
                    self.isProcessing?(false)
                    
                case .cancelled:
                    if let _error = export.error {
//                            failure(_error)
                    }
                    self.isProcessing?(false)
                default:
                    print("finished")
                    DispatchQueue.main.async {
                        self.currentURL = outputURL
                        self.videoFilter?(outputURL)
                        self.isProcessing?(false)
                    }
//                        success(outputURL)
                }
            })
        } else {
            self.isProcessing?(false)
        }
    }
    
}
extension FilterVideoView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
}
