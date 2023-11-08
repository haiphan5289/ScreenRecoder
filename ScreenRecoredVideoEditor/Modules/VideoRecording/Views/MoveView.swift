//
//  MoveView.swift
//  ScreenRecoredVideoEditor
//
//  Created by Hai Phan Thanh on 06/11/2023.
//

import UIKit

class MoveView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
}
