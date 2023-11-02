//
//  MoreActionCell.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 31/10/2023.
//

import UIKit

class MoreActionCell: UICollectionViewCell {

    @IBOutlet weak var iconMore: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
        layer.cornerRadius = 24
        layer.borderColor = Asset.eeeeee.color.cgColor
        layer.borderWidth = 1
    }
    
    func bindModel(type: MoreActionVC.MoreActionType) {
        iconMore.image = type.image
        titleLabel.text = type.title
    }

}
