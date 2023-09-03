
//
//  
//  ListFontDefaultVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 03/09/2023.
//
//
import UIKit
import RxCocoa
import RxSwift

class ListFontDefaultVC: UIViewController {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: ListFontDefaultVM = ListFontDefaultVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension ListFontDefaultVC {
    
    private func setupUI() {
        // Add here the setup for the UI
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
