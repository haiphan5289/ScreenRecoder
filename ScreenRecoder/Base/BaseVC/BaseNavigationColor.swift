//
//  BaseNavigationColor.swift
//  Beberia
//
//  Created by haiphan on 06/01/2022.
//  Copyright © 2022 IMAC. All rights reserved.
//

import UIKit
import RxSwift
import EasyBaseCodes

class BaseNavigationColor: UIViewController {

    let eventBackNavigation: PublishSubject<Void> = PublishSubject.init()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barTintColor = R.color.fd799dColor()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
//                                                                        NSAttributedString.Key.font: UIFont.init(name: "NotoSans-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18)]
//
//        self.customLeftBarButton()
//        self.setupNavigationiOS15(font: UIFont.init(name: "NotoSans-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18), isBackground: true)
    }
    
    func customLeftBarButton(){
//        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
//        buttonLeft.setImage( R.image.ic_back_white(), for: .normal)
//        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
//        navigationItem.leftBarButtonItem = leftBarButton
//        buttonLeft.rx.tap.bind { [weak self] _ in
//            guard let wSelf = self else { return }
//            wSelf.navigationController?.popViewController(animated: true, {
//                wSelf.eventBackNavigation.onNext(())
//            })
//        }.disposed(by: disposeBag)
    }
}
