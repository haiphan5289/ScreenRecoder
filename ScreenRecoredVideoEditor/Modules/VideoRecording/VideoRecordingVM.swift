
//
//  ___HEADERFILE___
//
import Foundation
import RxCocoa
import RxSwift
import EasyBaseAudio

class VideoRecordingVM {
    
    let allVideos: BehaviorRelay<[URL]> = BehaviorRelay(value: [])
    
    private let disposeBag = DisposeBag()
    init() {}
    
    func getAllVideo() {
        let values = AudioManage.shared.getItemsFolder(folder: ConstantApp.FolderName.editVideo.rawValue)
        allVideos.accept(values)
    }
}
