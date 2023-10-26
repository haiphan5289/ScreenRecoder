//
//  HomeCell.swift
//  ScreenRecoder
//
//  Created by haiphan on 20/05/2023.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var icImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HomeCell {
    
    func bindModel(model: HomeVCVC.HomeType) {
        bgView.backgroundColor = model.bgColor
        title.text = model.title
        subTitle.text = model.description
        icImage.image = model.image
    }
    
}
