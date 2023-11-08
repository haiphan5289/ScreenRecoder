//
//  VideoRecordingCell.swift
//  ScreenRecoredVideoEditor
//
//  Created by Hai Phan Thanh on 08/11/2023.
//

import UIKit
import RxCocoa
import RxSwift

class VideoRecordingCell: UICollectionViewCell {
    
    var selectHandler: (() -> Void)?

    @IBOutlet weak var thumnailImage: UIImageView!
    @IBOutlet weak var durationLabel: PaddingLabel!
    @IBOutlet weak var dateLabel: PaddingLabel!
    @IBOutlet weak var selectButton: UIButton!
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = dateLabel.frame.height / 2
        durationLabel.clipsToBounds = true
        durationLabel.layer.cornerRadius = dateLabel.frame.height / 2
        selectButton.isHidden = true
        setupRX()
    }

}

extension VideoRecordingCell {
    
    private func setupRX() {
        
        selectButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.selectHandler?()
            }.disposed(by: disposeBag)
    }
    
    func bindModel(url: URL) {
        thumnailImage.image = url.getThumbnailImage()
        durationLabel.text = Int(url.getDuration()).getTextFromSecond()
        dateLabel.text = "\(url.creation?.covertToString(format: .HHmmEEEEddMMyyyy) ?? "")"
    }
    
    func hiddenButton(hidden: Bool) {
        selectButton.isHidden = hidden
    }
    
    func selectButton(selected: Bool) {
        let image = selected ? Asset.icDone.image : Asset.icUncheckBox.image
        selectButton.setImage(image, for: .normal)
    }
}
