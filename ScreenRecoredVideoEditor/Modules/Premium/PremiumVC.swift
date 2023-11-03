//
//  PremiumVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by Hai Phan Thanh on 03/11/2023.
//

import UIKit
import RxCocoa
import RxSwift

class PremiumVC: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
        // Do any additional setup after loading the view.
    }
}
extension PremiumVC {
    
    private func setupUI() {}
    
    private func setupRX() {
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    
}
