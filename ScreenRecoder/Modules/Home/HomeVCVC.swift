
//
//  
//  HomeVCVC.swift
//  ScreenRecoder
//
//  Created by haiphan on 20/05/2023.
//
//
import UIKit
import RxCocoa
import RxSwift

class HomeVCVC: BaseVC, SetupTableView {
    
    
    enum HomeType: Int, CaseIterable {
        case liveStream, screen, facecam, videoEditor, commentary
        
        var title: String? {
            switch self {
            case .liveStream: return "Live Stream"
            case .screen: return "Screen Recorder"
            case .facecam: return "Face Cam"
            case .videoEditor: return "Video Editor"
            case .commentary: return "Commentary"
            }
        }
        
        var description: String? {
            switch self {
            case .liveStream: return "Hight quality & fast streaming to YouTube, Twitch, Facebook..."
            case .screen: return "Recording your screen with best quality"
            case .facecam: return "React to videos from Screen Recordings, Camera Roll or Youtube"
            case .videoEditor: return "Quick and easy video edit for sharing"
            case .commentary: return "Add commentary to videos from Screen Recordings or Camera Roll"
            }
        }
        
        var bgColor: UIColor? {
            switch self {
            case .liveStream: return Asset.bgLive.color
            case .screen: return Asset.bgScreen.color
            case .facecam: return Asset.bgFaceCam.color
            case .videoEditor: return Asset.bgVideoEditor.color
            case .commentary: return Asset.bgComment.color
            }
        }
        
    }
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: HomeVCVM = HomeVCVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension HomeVCVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        navigationType = .hide
        setupTableView(tableView: tableView,
                       delegate: self,
                       name: HomeCell.self)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        Driver.just(HomeType.allCases)
            .drive(tableView.rx.items(cellIdentifier: HomeCell.identifier,
                                      cellType: HomeCell.self)) {(row, element, cell) in
                cell.bindModel(model: element)
            }.disposed(by: disposeBag)
    }
}
extension HomeVCVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
