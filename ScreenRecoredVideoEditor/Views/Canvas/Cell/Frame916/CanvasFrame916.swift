//
//  CanvasFrame916.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 03/10/2023.
//

import UIKit

class CanvasFrame916: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func selectedCell(isSelected: Bool) {
        containerView.layer.borderColor = isSelected ? Asset._177Cef.color.cgColor : Asset.c1C1C1.color.cgColor
    }

}
