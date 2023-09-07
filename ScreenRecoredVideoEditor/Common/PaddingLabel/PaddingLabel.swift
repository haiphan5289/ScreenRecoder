//
//  PaddingLabel.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 05/09/2023.
//

import Foundation
import UIKit

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        numberOfLines = 0
        let size = super.intrinsicContentSize
        return CGSize(width: min(size.width + leftInset + rightInset, 10000), height: min(size.height + topInset + bottomInset, 10000))
    }

//    override var bounds: CGRect {
//        didSet {
//            // ensures this works within stack views if multi-line
//            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
//        }
//    }
    
    override func textRect(forBounds bounds:CGRect,
                               limitedToNumberOfLines n:Int) -> CGRect {
        let b = bounds
        let tr = b.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: 0)
        // that line of code MUST be LAST in this function, NOT first
        return ctr
    }
}
