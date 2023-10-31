
//
//  
//  MoreActionVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 29/10/2023.
//
//
import UIKit
import RxCocoa
import RxSwift

class MoreActionVC: UIViewController, SetupBaseCollection {
    
    
    enum MoreActionType: Int, CaseIterable {
        case getPremium, rateApp, contact, shareApp, policy, terms
        
        var title: String {
            switch self {
            case .getPremium: return "Get Premium"
            case .rateApp: return "Rate App"
            case .contact: return "Contact Us"
            case .shareApp: return "Share App"
            case .policy: return "Privacy Policy"
            case .terms: return "Terms Of Users"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .getPremium: return Asset.icPremiumMore.image
            case .rateApp: return Asset.icRateMore.image
            case .contact: return Asset.icContactMore.image
            case .shareApp: return Asset.icShareMore.image
            case .policy: return Asset.icPrivacyMore.image
            case .terms: return Asset.icTermsMore.image
            }
        }
        
    }
    
    // Add here outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Add here your view model
    private var viewModel: MoreActionVM = MoreActionVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension MoreActionVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        setupCollectionView(collectionView: collectionView,
                            delegate: self,
                            name: MoreActionCell.self)
        collectionView.dataSource = self
        collectionView.register(MoreActionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MoreActionHeaderView.identifier)

        
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
extension MoreActionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoreActionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreActionCell.identifier, for: indexPath) as? MoreActionCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       viewForSupplementaryElementOfKind kind: String,
                       at indexPath: IndexPath) -> UICollectionReusableView {

       switch kind {

       case UICollectionView.elementKindSectionHeader:
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MoreActionCell.identifier, for: indexPath)
           headerView.backgroundColor = UIColor.blue
           return headerView
       default:
           assert(false, "Unexpected element kind")
       }
   }
    
    
}
extension MoreActionVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
}
