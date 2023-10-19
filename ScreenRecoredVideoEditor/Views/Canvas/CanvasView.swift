//
//  CanvasView.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 03/10/2023.
//

import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio

class CanvasView: UIView {
    
    enum CanasViewType: Int, CaseIterable {
        case noFrame, oneone, fourfive, sixteennine, ninesixteeen
    }
    
    var inputVideo: URL?
    var changeVideoURL: ((URL, CanvasView.CanasViewType) -> Void)?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private var selectIndex = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
        
    }
}
extension CanvasView {
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibWithCellClass: CanvasCell.self)
        collectionView.register(nibWithCellClass: CanvasFrame11.self)
        collectionView.register(nibWithCellClass: CanvasFrame45.self)
        collectionView.register(nibWithCellClass: CanvasFrame169.self)
        collectionView.register(nibWithCellClass: CanvasFrame916.self)
    }
    
    private func setupRX() {
        
    }
    
}
extension CanvasView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CanasViewType.allCases.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = CanasViewType(rawValue: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        switch type {
        case .noFrame:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasCell.identifier, for: indexPath) as? CanvasCell else {
                return UICollectionViewCell()
            }
            cell.selectedCell(isSelected: self.selectIndex == indexPath.row)
            return cell
        case .oneone:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasFrame11.identifier, for: indexPath) as? CanvasFrame11 else {
                return UICollectionViewCell()
            }
            cell.selectedCell(isSelected: self.selectIndex == indexPath.row)
            return cell
        case .fourfive:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasFrame45.identifier, for: indexPath) as? CanvasFrame45 else {
                return UICollectionViewCell()
            }
            cell.selectedCell(isSelected: self.selectIndex == indexPath.row)
            return cell
        case .sixteennine:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasFrame169.identifier, for: indexPath) as? CanvasFrame169 else {
                return UICollectionViewCell()
            }
            cell.selectedCell(isSelected: self.selectIndex == indexPath.row)
            return cell
        case .ninesixteeen:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasFrame916.identifier, for: indexPath) as? CanvasFrame916 else {
                return UICollectionViewCell()
            }
            cell.selectedCell(isSelected: self.selectIndex == indexPath.row)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let videoURL = self.inputVideo,
           let type = CanasViewType(rawValue: indexPath.row) {
            self.selectIndex = indexPath.row
            collectionView.reloadData()
            self.changeVideoURL?(videoURL, type)
//            AudioManage.shared.changeSizeVideo(videoUrl: videoURL,
//                                               folderName: ConstantApp.FolderName.editVideo.rawValue) { [weak self] outputURL in
//                guard let self = self else { return }
//                self.changeVideoURL?(outputURL)
//            } failure: { [weak self] error in
//                guard let self = self else { return }
//
//            }

        }
        
        
    }
}

extension CanvasView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 54, height: 54)
    }
}
